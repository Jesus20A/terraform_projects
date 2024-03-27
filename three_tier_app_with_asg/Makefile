all: tar_app packer_build tf_init tf_apply

tar_app:
	tar -czf ./packer/provisioning/shell/app.tar.gz app

packer_build:
	packer build ./packer/app-serv.pkr.hcl


tf_init:
	terraform -chdir=./terraform/ init

tf_apply:
	terraform -chdir=./terraform/ apply -auto-approve

clean:
	terraform -chdir=./terraform/ destroy -auto-approve
	rm ./packer/provisioning/shell/app.tar.gz
	rm ./terraform/terraform.tfstate.backup
	rm ./terraform/terraform.tfstate
	rm -rf ./terraform/.terraform
	rm ./terraform/.terraform.lock.hcl

