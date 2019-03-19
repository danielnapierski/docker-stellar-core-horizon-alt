# Guide to Provisioning an Onfo Observer Node

This guide will cover the steps to provision an Onfo Observer Node that will participate in the public Onfo network.  The virtual infrastructure will be hosted on AWS.  Resources will be provisioned using Terraform and configured using Ansible.

### Prerequisites
* AWS account credentials
  * generate credentials in the management studio with privileges to provision EC2 instances.
  * specify [default] access_key and secret_key in ~/.aws/credentials.


    $ cat ~/.aws/credentials
    [default]
    aws_access_key_id = YOURKEYXYZ
    aws_secret_access_key = YOURSECRETXYZ


  * AWS SSH Key
    * generate an ssh key to unlock remote access to provisioned resources.  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
    * the key will be specified by name during provisioning
    * maintain a local copy of the private key and use it to connect for configuration.


      $ export ONFO_OBS_NODE_SSH_KEY=/fullpath/ONFO_SSH_KEY.pem
      $ export ONFO_OBS_NODE_USER="ec2-user"


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

    $ cd ./tf/

***Note:*** There are many ways that variables could be configured.  This is one approach.  We will set environment variables using the prefix TF_VAR_ that will be read and replaced by terraform.  See ./tf/observer.tf for details.  Below we will set values that must match resources already configured in your AWS environment, specifically a keypair and security group.  The security group must allow for remote access by SSH.


    $ export TF_VAR_ssh_key_name="yourkeyname"
    $ export TF_VAR_security_group="yourgroupname"


We also need to specify both an ami instance and region.  Ami instances are specific to a region, so be sure to chose an ami available on the region you specify.  We use default values if these options are not specified.

    $ export TF_VAR_region="yourregion"
    $ export TF_VAR_ami="yourami"
    $ export TF_VAR_instance_type="yourinstancetype"

Initialize terraform.  Load the plan.  Apply the plan.  You will be asked to confirm.

    $ terraform init
    $ terraform plan
    $ terraform apply

Show the results.  Confirm the resource was created using the desired key_name.  Inspect the full dns name of this resource.

    $ terraform show
    $ terraform show | grep 'key_name'
    $ terraform show | grep 'public_dns'

Read the public DNS address and store it as an environment variable.

    $ export ONFO_OBS_NODE_DNS=$(terraform show | grep 'public_dns' | sed 's/^.*= //')
    $ echo $ONFO_OBS_NODE_DNS





Test an ssh connection to the resource.

    $ ssh -i ${ONFO_OBS_NODE_SSH_KEY} ${ONFO_OBS_NODE_USER}'@'${ONFO_OBS_NODE_DNS}

    # Within an SSH terminal session confirm infrastructure details using AWS commands.

    $ ec2-metadata
    # Results...

    $ exit

### Inventory

Change to the directory containing hosts.ini and observer.yaml.

`cd ../`

Edit hosts.ini to match your inventory, which should only include a single EC2 resource DNS address under `[observer_nodes]`.  Or use the results from `terraform show`, parsed and stored as `$ONFO_OBS_NODE_DNS`, to generate the contents, as shown below.

    $ rm ./hosts.ini; echo "[observer_nodes]" >> hosts.ini; echo $ONFO_OBS_NODE_DNS >> hosts.ini
    $ cat hosts.ini


### Ansible

The following command will run the observer.yaml playbook against the inventory in hosts.ini using the ONFO ssh key to connect to the resource.

    $ ansible-playbook -i hosts.ini --private-key=$ONFO_OBS_NODE_SSH_KEY -u $ONFO_OBS_NODE_USER observer.yaml

Once this playbook completes you should your observer node up and running at:

    $ wget ${ONFO_OBS_NODE_DNS}':11626/info'

# DRAFT - more to compute
### Configure database and s3


### Destroy

When the time comes to destroy all the resources:

    cd ./tf
    teffaform destroy
