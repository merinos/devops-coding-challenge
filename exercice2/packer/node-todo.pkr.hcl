packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "debian" {
  ami_name      = "node-todo"
  instance_type = "t3a.micro"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      name                = "debian-12-amd64-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["136693071363"]
  }
  ssh_username = "admin"
}

build {
  name = "node-todo"
  sources = [
    "source.amazon-ebs.debian"
  ]

  provisioner "file" {
    source      = "./node-todo.service"
    destination = "/tmp/node-todo.service"
  }

  provisioner "file" {
    source      = "./database.js"
    destination = "/tmp/database.js"
  }


  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    inline = [
      "sudo apt-get -yq update",
      "sudo apt-get -yq dist-upgrade",
      "sudo apt-get -yq install git curl gnupg",
      "echo 'deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main' | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list",
      "curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor",
      "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -",
      "sudo apt-get -yq update",
      "sudo apt-get -yq install nodejs mongodb-org-server",
      "cd /opt && sudo git clone https://github.com/scotch-io/node-todo.git",
      "cd /opt/node-todo && sudo npm install",
      "sudo mv /tmp/node-todo.service /etc/systemd/system/",
      "sudo mv /tmp/database.js /opt/node-todo/config/",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable node-todo.service",
      "sudo systemctl enable mongod.service",
    ]
  }
  provisioner "file" {
    source      = "./authorized_keys"
    destination = "/home/admin/.ssh/authorized_keys"
  }
}
