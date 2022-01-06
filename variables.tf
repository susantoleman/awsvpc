##############################################################################################################
#
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment -
#
##############################################################################################################

# Access and secret keys to your environment
variable "access_key" {}
variable "secret_key" {}

# Prefix for all resources created for this deployment in AWS
variable "tag_name_prefix" {
  description = "Provide a common tag prefix value that will be used in the name tag for all resources"
  default     = "3Tier"
}

variable "tag_name_unique" {
  description = "Provide a unique tag prefix value that will be used in the name tag for each modules resources"
  default     = ""
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default     = "byol"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "replace_with_your_license_one_file_name.lic"
}

// license file for the passive fgt
variable "license2" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "replace_with_your_license_two_file.lic"
}

#############################################################################################################
#  AMI

// AMIs are for FGTVM-AWS(PAYG) - 7.0.2
variable "fgt-ond-amis" {
  type = map
  default = {
    us-west-2      = "ami-0e569295bb3f6ab11"
    us-west-1      = "ami-095959eb30adfa9a3"
    us-east-1      = "ami-0f37125f0c38e8ea8"
    us-east-2      = "ami-06793c2af5608535d"
    ap-east-1      = "ami-0699af54b4633491a"
    ap-south-1     = "ami-0a127f57954a4a1f2"
    ap-northeast-3 = "ami-09ad17171ea4eff8d"
    ap-northeast-2 = "ami-0d3c494bb99d82447"
    ap-southeast-1 = "ami-00112697759f99d8d"
    ap-southeast-2 = "ami-07452c768a8cbed39"
    ap-northeast-1 = "ami-03e8c6e055020dd9b"
    ca-central-1   = "ami-0ede51ef40cee3efa"
    eu-central-1   = "ami-07e1b42208e73e245"
    eu-west-1      = "ami-0fab4ac7da7ff40e7"
    eu-west-2      = "ami-0c061b51af9e9b077"
    eu-south-1     = "ami-0cb93c71083b7dae7"
    eu-west-3      = "ami-0fdfb85a314198974"
    eu-north-1     = "ami-03107d291accd5ea4"
    me-south-1     = "ami-0ad2dfcb40065e84a"
    sa-east-1      = "ami-03dde0d83f69a5982"
  }
}


// AMIs are for FGTVM AWS(BYOL) - 7.0.2
variable "fgtvmbyolami" {
  type = map
 default = {
    us-west-2      = "ami-05558fc4d58e0311d"
    us-west-1      = "ami-02b8386b83b22a768"
    us-east-1      = "ami-03b05077372374ac2"
    us-east-2      = "ami-0d64f9d41d2c347fe"
    ap-east-1      = "ami-0aebd5b952425a493"
    ap-south-1     = "ami-015b6108d837a11bb"
    ap-northeast-3 = "ami-09eabd6630c92b02f"
    ap-northeast-2 = "ami-0575bff848509c6d8"
    ap-southeast-1 = "ami-0c36d980e164c3372"
    ap-southeast-2 = "ami-06217cfb67db81bd7"
    ap-northeast-1 = "ami-046d2f9510157fe5a"
    ca-central-1   = "ami-014a19c8175403554"
    eu-central-1   = "ami-090da6c908c1127f6"
    eu-west-1      = "ami-082aa757173803c84"
    eu-west-2      = "ami-0ab723f14117aa285"
    eu-south-1     = "ami-0472705b9d0a4e155"
    eu-west-3      = "ami-0b4e3a514d31d3a79"
    eu-north-1     = "ami-0a48ff95e49c70174"
    me-south-1     = "ami-03a43777cd244fca4"
    sa-east-1      = "ami-094f94451eda5df8b"
  }
}

variable "scenario" {
  default = "ha-tgw"
}

// password for FortiGate HA configuration
variable "password" {
  default = "fortinet"
}
# References of your environment
variable "region" {
  description = "Provide the region to deploy the VPC in"
  default     = "ap-southeast-1"
}

variable "availability_zone1" {
  description = "Provide the first availability zone to create the subnets in"
  default     = "ap-southeast-1a"
}

variable "availability_zone2" {
  description = "Provide the second availability zone to create the subnets in"
  default     = "ap-southeast-1b"
}
######## Major-Net used
variable "all_vpc_cidr" {
  description = "Provide the network CIDR for the VPC"
  default     = "10.0.0.0/8"
}

# References to your Networks
# security VPC
variable "security_vpc_cidr" {
  description = "Provide the network CIDR for the VPC"
  default     = "10.0.0.0/16"
}

#### public subnets
variable "security_vpc_public_subnet_cidr1" {
  description = "Provide the network CIDR for the public subnet1 in security vpc"
  default     = "10.0.1.0/24"
}

variable "security_vpc_public_gw1" {
  description = "Provide the default local router IP for the subnet1"
  default     = "10.0.1.1/24"
}

variable "security_vpc_public_subnet_cidr2" {
  description = "Provide the network CIDR for the data subnet1 in security vpc"
  default     = "10.0.10.0/24"
}

variable "security_vpc_public_gw2" {
  description = "Provide the default local router IP for the subnet2"
  default     = "10.0.10.1/24"
}

### private subnets

variable "security_vpc_private_subnet_cidr1" {
  description = "Provide the network CIDR for the private subnet1 in security vpc"
  default     = "10.0.2.0/24"
}

variable "security_vpc_private_gw1" {
  description = "Provide the default local router IP for the subnet1"
  default     = "10.0.2.1/24"
}

variable "security_vpc_private_subnet_cidr2" {
  description = "Provide the network CIDR for the data subnet1 in security vpc"
  default     = "10.0.20.0/24"
}

variable "security_vpc_private_gw2" {
  description = "Provide the default local router IP for the subnet2"
  default     = "10.0.20.1/24"
}


#### TGW subnets
variable "security_vpc_tgw_subnet_cidr1" {
  description = "Provide the network CIDR for the tgw subnet1 in security vpc"
  default     = "10.0.101.0/24"
}

variable "security_vpc_tgw_subnet_cidr2" {
  description = "Provide the network CIDR for the tgw subnet2 in security vpc"
  default     = "10.0.102.0/24"
}

#### mgmt subnets
variable "security_vpc_mgmt_subnet_cidr1" {
  description = "Provide the network CIDR for the mgmt subnet1 in security vpc"
  default     = "10.0.3.0/24"
}

variable "security_vpc_mgmt_subnet1_gw" {
  description = "Provide the default local router IP for the subnet1"
  default     = "10.0.3.1/24"
}

variable "security_vpc_mgmt_subnet_cidr2" {
  description = "Provide the network CIDR for the mgmt subnet2 in security vpc"
  default     = "10.0.30.0/24"
}

variable "security_vpc_mgmt_subnet2_gw" {
  description = "Provide the default local router IP for the subnet2"
  default     = "10.0.30.1/24"
}

#### Heartbeat subnets
variable "security_vpc_heartbeat_subnet_cidr1" {
  description = "Provide the network CIDR for the public subnet1 in security vpc"
  default     = "10.0.4.0/24"
}

variable "security_vpc_heartbeat_subnet_cidr2" {
  description = "Provide the network CIDR for the public subnet1 in security vpc"
  default     = "10.0.40.0/24"
}

# web VPC
variable "web_vpc_cidr" {
  description = "Provide the network CIDR for the VPC"
  default     = "10.1.0.0/16"
}

variable "web_vpc_private_subnet_cidr1" {
  description = "Provide the network CIDR for the private subnet1 in web vpc"
  default     = "10.1.1.0/24"
}

variable "web_vpc_private_subnet_cidr2" {
  description = "Provide the network CIDR for the private subnet2 in web vpc"
  default     = "10.1.10.0/24"
}

# app VPC
variable "app_vpc_cidr" {
  description = "Provide the network CIDR for the VPC"
  default     = "10.2.0.0/16"
}

variable "app_vpc_private_subnet_cidr1" {
  description = "Provide the network CIDR for the private subnet1 in app vpc"
  default     = "10.2.1.0/24"
}

variable "app_vpc_private_subnet_cidr2" {
  description = "Provide the network CIDR for the private subnet1 in app vpc"
  default     = "10.2.10.0/24"
}

# db VPC
variable "db_vpc_cidr" {
  description = "Provide the network CIDR for the VPC"
  default     = "10.3.0.0/16"
}

variable "db_vpc_private_subnet_cidr1" {
  description = "Provide the network CIDR for the private subnet1 in db vpc"
  default     = "10.3.1.0/24"
}

variable "db_vpc_private_subnet_cidr2" {
  description = "Provide the network CIDR for the private subnet1 in db vpc"
  default     = "10.3.10.0/24"
}


# Mgmt VPC
variable "mgmt_vpc_cidr" {
  description = "Provide the network CIDR for the Mgmt VPC"
  default     = "10.4.0.0/16"
}

variable "mgmt_private_subnet_cidr1" {
  description = "Provide the network CIDR for the mgmt subnet1 in spoke mgmt"
  default     = "10.4.1.0/24"
}

variable "mgmt_private_subnet_cidr2" {
  description = "Provide the network CIDR for the mgmt subnet2 in spoke mgmt"
  default     = "10.4.10.0/24"
}

# References to your FortiGate
variable "ami" {
  description = "Provide an AMI for the FortiGate instances"
  default     = "automatically gathered by terraform modules"
}

variable "instance_type" {
  description = "Provide the instance type for the FortiGate instances"
  default     = "c5.xlarge"
}

variable "keypair" {
  description = "Provide a keypair for accessing the FortiGate instances"
  default     = "sleman-keypairs-sydney"
}

variable "cidr_for_access" {
  description = "Provide a network CIDR for accessing the FortiGate instances"
  default     = "0.0.0.0/0"
}

variable "forwarding_config" {
  default = {
    80  = "TCP"
  }
}

variable "healthport" {
  default = "80"
}
variable "target1_id" {
  default = "10.1.1.100"
}

variable "target2_id" {
  default = "10.1.10.100"
}

variable "fgt1_public_eni" {
  default = "10.0.1.100"
}

variable "fgt2_public_eni" {
  default = "10.0.10.100"
}

variable "az1_nlb" {
  default = "10.1.1.99"
}

variable "az2_nlb" {
  default = "10.1.10.99"
}

variable "fqdn_nlb" {
  default  = "your_nlb_arn.elb.your_aws_region.amazonaws.com"
}
