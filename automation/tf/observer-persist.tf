resource "aws_instance" "observer-persist" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
# this is for connecting by ssh
# the associated private key must be provided when connecting:
# --private-key=/full/path/to/key.pem
# $ export TF_VAR_ssh_key_name="yourkeyname"
  key_name      = "${var.ssh_key_name}"
  security_groups = ["${var.security_group}"]
  tags = {
    Name = "Onfo Observer-Persist Node DO"
  }
}
