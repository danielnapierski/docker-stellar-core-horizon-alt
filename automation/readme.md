# Guide to Provisioning an Onfo Observer Node

This guide will cover the steps to provision an Onfo Observer Node that will participate in the public Onfo network.  The virtual infrastructure will be hosted on AWS.  Resources will be provisioned using Terraform and configured using Ansible.

### Prerequisites
* AWS account credentials
  * generate credentials in the management studio with privileges to provision EC2 instances.
  * specify [default] access_key and secret_key in ~/.aws/credentials.
  * ```$ cat ~/.aws/credentials```


    [default]
    aws_access_key_id = YOURKEYXYZ
    aws_secret_access_key = YOURSECRETXYZ
  * AWS SSH Key
    * generate an ssh key to unlock remote access to provisioned resources.  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
    * the key will be specified by name during provisioning
    * maintain a local copy of the private key and use it to connect for configuration.
    * `$ export ONFO_OBS_NODE_SSH_KEY=/fullpath/ONFO_SSH_KEY.pem`


* Terraform
  * https://www.terraform.io/downloads.html
  * `$ terraform --version`
  * Expect 'Terraform v0.11.11' or higher.


* Ansible
  * https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
  * `$ ansible-playbook --version`
  * Expect 'ansible-playbook 2.7.8' or higher.

### Getting Started

Change to the tf/ directory.

`$ cd ./tf/`

***Note:*** There are many ways that variables could be configured.  This is one approach.  We will set environment variables using the prefix TF_VAR_ that will be read and replaced by terraform.  See ./tf/observer.tf for details.  Below we will set values that must match resources already configured in your AWS environment, specifically a keypair and security group.  The security group must allow for remote access by SSH.


`$ export TF_VAR_ssh_key_name="yourkeyname"`


`$ export TF_VAR_security_group="yourgroupname"`


We also need to specify both an ami instance and region.  Ami instances are specific to a region, so be sure to chose an ami available on the region you specify.  We use default values if these options are not specified.

`$ export TF_VAR_region="yourregion"`

`$ export TF_VAR_ami="yourami"`

`$ export TF_VAR_instance_type="yourinstancetype"`

Initialize terraform.

`$ terraform init`

Load the plan.

`$ terraform plan`

Apply the plan.  You will be asked to confirm.

`$ terraform apply`

Show the results.

`$ terraform show`

Confirm the resource was created using the desired key_name.

`$ terraform show | grep 'key_name'`

Inspect the full dns name of this resource.

`$ terraform show | grep 'public_dns'`

Export variables.

`$ export ONFO_OBS_NODE_DNS=` [copy&paste]

`$ export ONFO_OBS_NODE_USER='ec2-user'`

Test an ssh connection to the resource.

NEED TO FIX FORMATTING/STRING CONCAT

`$ ssh -i $ONFO_SSH_KEY $ONFO_OBS_NODE_USER'@'$ONFO_OBS_NODE_DNS`


### Inventory

Change to the directory containing hosts.ini and observer.yaml.

`cd ../`

Edit hosts.ini.  Or use the results from terraform show generate the contents.

### Ansible

The following command will run the observer.yaml playbook against the inventory in hosts.ini using the ONFO ssh key to connect to the resource.

`$ ansible-playbook -i hosts.ini --private-key=$ONFO_OBS_NODE_SSH_KEY -u $ONFO_OBS_NODE_USER observer.yaml`

# DRAFT - more to compute
