

variable "ssh_key_name" {
    type = "string"
}

variable "security_group" {
    type = "string"
}

variable "ami" {
    type = "string"
    default = "ami-0cd3dfa4e37921605"
}

variable "instance_type" {
    type = "string"
    default = "t3.2xlarge"
}

variable "region" {
    type = "string"
    default = "us-east-2"
}

provider "aws" {
# specify [default] access_key and secret_key in ~/.aws/credentials)
  region     = "${var.region}"
  version    = "~> 2.0"
}

resource "aws_instance" "observer" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
# this is for connecting by ssh
# the associated private key must be provided when connecting:
# --private-key=/full/path/to/key.pem
# $ export TF_VAR_ssh_key_name="yourkeyname"
  key_name      = "${var.ssh_key_name}"
  security_groups = ["${var.security_group}"]
  tags = {
    Name = "Onfo Observer Node"
  }
}
