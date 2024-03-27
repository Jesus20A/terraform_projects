from flask import Flask, render_template, request, redirect, flash, render_template_string, g
from flask_mysqldb import MySQL
from flask_wtf import CSRFProtect
from flask_login import LoginManager, login_user, logout_user, login_required
import requests
import subprocess
import json

from config import config

# Models:
from models.ModelUser import ModelUser

# Entities:
from models.entities.User import User

import json
import requests


def get_instance_document():
    try:
        r = requests.get("http://169.254.169.254/latest/dynamic/instance-identity/document")
        if r.status_code == 401:
            token=(
                requests.put(
                    "http://169.254.169.254/latest/api/token",
                    headers={'X-aws-ec2-metadata-token-ttl-seconds': '21600'},
                    verify=False, timeout=1
                )
            ).text
            r = requests.get(
                "http://169.254.169.254/latest/dynamic/instance-identity/document",
                headers={'X-aws-ec2-metadata-token': token}, timeout=1
            )
        r.raise_for_status()
        return r.json()
    except:
        print(" * Instance metadata not available")
        return { "availabilityZone" : "us-fake-1a",  "instanceId" : "i-fakeabc" }

doc = get_instance_document()
availablity_zone = doc["availabilityZone"]
instance_id = doc["instanceId"]

app = Flask(__name__)
app.config.from_object(config['development'])

csrf = CSRFProtect(app)
db = MySQL(app)
login_manager_app = LoginManager(app)


@login_manager_app.user_loader
def load_user(id):
    return ModelUser.get_by_id(db, id)

@app.before_request
def before_request():
    "Set up globals referenced in jinja templates"
    g.availablity_zone = availablity_zone
    g.instance_id = instance_id

@app.route('/')
def index():
    return redirect('/login')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = User(0, request.form['username'], request.form['password'])
        logged_user = ModelUser.login(db, user)
        if logged_user != None:
            if logged_user.password:
                login_user(logged_user)
                return redirect('/home')
            else:
                flash("Invalid password...")
                return render_template('auth/login.html')
        else:
            flash("User not found...")
            return render_template('auth/login.html')
    else:
        return render_template('auth/login.html')


@app.route('/logout')
def logout():
    logout_user()
    return redirect('/login')


@app.route('/home')
@login_required
def home():
    return render_template('/home.html')

@app.route('/health')
def health():
    return render_template('/health.html')

@app.route('/protected')
@login_required
def protected():
    return "<h1>Esta es una vista protegida, solo para usuarios autenticados.</h1>"


@app.route('/info')
@login_required
def info():
    "Webserver info route"
    return render_template_string("""
            {% extends "base.html" %}
            {% block head %}
                Instance Info
            {% endblock %}
            {% block body %}
            <b>instance_id</b>: {{g.instance_id}} <br/>
            <b>availability_zone</b>: {{g.availablity_zone}} <br/>
            <hr/>
            {% if messages %}
            <br />
            {% for message in messages %}
            <div class="alert alert-primary alert-dismissible" role="alert">
                <strong>{{ message }}</strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            {% endfor %}
            {% endif %}
            <small>Stress cpu:
            <a href="{{ url_for('stress', seconds=60) }}">1 min</a>,
            <a href="{{ url_for('stress', seconds=180) }}">3 min</a>,
            <a href="{{ url_for('stress', seconds=300) }}">5 min</a>
            </small>
            {% endblock %}""")

@app.route("/info/stress_cpu/<seconds>")
@login_required
def stress(seconds):
    "Max out the CPU"
    flash("Stressing CPU")
    subprocess.Popen(["stress", "--cpu", "2", "--timeout", seconds])
    return redirect('/info')



def status_401(error):
    return redirect('/login')


def status_404(error):
    return "<h1>Página no encontrada</h1>", 404


if __name__ == '__main__':
    app.register_error_handler(401, status_401)
    app.register_error_handler(404, status_404)
