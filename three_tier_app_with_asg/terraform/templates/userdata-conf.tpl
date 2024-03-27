#!/bin/bash

cat  <<'EOT' >> /home/ec2-user/flask_login.sql
USE flask_app;
CREATE TABLE `user` (
  `id` smallint(3) UNSIGNED NOT NULL,
  `username` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `password` char(102) COLLATE utf8_unicode_ci NOT NULL,
  `fullname` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores the user''s data.';

INSERT INTO `user` (`id`, `username`, `password`, `fullname`) VALUES
(1, 'Jesus', 'pbkdf2:sha256:260000$56j6bqQVJmp96jJ8$18613216d57fc20d8b995b23fda48498ef280e7ae9ef9fd50297502bdcb36a5c', 'Jesus Salas');

ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `user`
  MODIFY `id` smallint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;
EOT

cat  <<'EOT' >> /home/ec2-user/.my.cnf
[client]
user=${db_user}
password=${db_password}
EOT

chmod 600 /home/ec2-user/.my.cnf 

chown ec2-user:ec2-user /home/ec2-user/.my.cnf

chown ec2-user:ec2-user /home/ec2-user/flask_login.sql

wget https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm

dnf install mysql80-community-release-el9-5.noarch.rpm -y

dnf install mysql-community-server -y

systemctl start mysqld

su ec2-user -c 'mysql --defaults-file=/home/ec2-user/.my.cnf -h ${db_host} < /home/ec2-user/flask_login.sql'

if [ $? -eq 0 ]; then
    echo "ok" > /home/ec2-user/db_check.txt

else
    echo "fail" > /home/ec2-user/db_check.txt

fi

#Test ssh-key, no longer available
cat  <<'EOT' >> /home/ec2-user/.ssh/conf-key.pem
-----BEGIN OPENSSH PRIVATE KEY-----
FJOWSIEHRHHHHHHH45345WJKHNWUI4W894WEIFHWIEFWE
FWEIJT48898WIOCKVNMFNGJNOEIUH98HGLIKKLKKKKKRY
GOOJK4OPKJOPKJLKJOJ3O3IKK444KNMOIMBPHFGH56O66
-----END OPENSSH PRIVATE KEY-----
EOT

chmod 600 /home/ec2-user/.ssh/conf-key.pem
chown ec2-user:ec2-user /home/ec2-user/.ssh/conf-key.pem


