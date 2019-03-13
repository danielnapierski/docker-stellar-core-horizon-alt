provider "aws" {
# specify [default] access_key and secret_key in ~/.aws/credentials)
  region     = "us-east-2"
  version    = "~> 2.0"
}

resource "aws_instance" "observer" {
  ami           = "ami-0cd3dfa4e37921605"
  instance_type = "t3.2xlarge"
# this is for ssh connecting
# the associated private key must be provided when connecting:
# --private-key=/full/path/to/key.pem
# TODO: move to variables.tf
  key_name      = "{readfromvar}"
  security_groups = ["{readfromvar}"]
  tags = {
    Name = "Onfo Observer Node"
  }
}
