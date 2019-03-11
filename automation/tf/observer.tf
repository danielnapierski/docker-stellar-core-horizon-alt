provider "aws" {
# TODO put credentials in ~/.aws/credentials)
  access_key = "AKIAIWSTXNPR5IBRANIA"
  secret_key = "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"
  region     = "us-east-2"
  version    = "~> 2.0"
}

resource "aws_instance" "observer" {
  ami           = "ami-0cd3dfa4e37921605"
  instance_type = "t3.2xlarge"
  key_name      = "OnfoDevOpsKeyPair"
  security_groups = ["launch-wizard-9"]
  tags = {
    Name = "Onfo Observer Node"
  }
}
