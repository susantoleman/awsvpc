##############################################################################################################
#
# AWS Transit Gateway
# FortiGate setup with Active/Passive in Multiple Availability Zones
#
##############################################################################################################

##############################################################################################################
# GENERAL
##############################################################################################################

# Security Groups
## Need to create 4 of them as our Security Groups are linked to a VPC

resource "aws_security_group" "NSG-webvpc-ssh-icmp-https" {
  name        = "NSG-webvpc-ssh-icmp-https"
  description = "Allow SSH, HTTPS and ICMP traffic"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "NSG-webvpc-ssh-icmp-https"
    scenario = var.scenario
  }
}

resource "aws_security_group" "NSG-appvpc-ssh-icmp-https" {
  name        = "NSG-appvpc-ssh-icmp-https"
  description = "Allow SSH, HTTPS and ICMP traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1 # all icmp
    to_port     = -1 # all icmp
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "NSG-appvpc-ssh-icmp-https"
    scenario = var.scenario
  }
}

resource "aws_security_group" "NSG-dbvpc-ssh-icmp-https" {
  name        = "NSG-dbvpc-ssh-icmp-https"
  description = "Allow SSH, HTTPS and ICMP traffic"
  vpc_id      = aws_vpc.db_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1 # all icmp
    to_port     = -1 # all icmp
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "NSG-dbvpc-ssh-icmp-https"
    scenario = var.scenario
  }
}


resource "aws_security_group" "NSG-mgmt-ssh-icmp-https" {
  name        = "NSG-mgmt-ssh-icmp-https"
  description = "Allow SSH, HTTPS and ICMP traffic"
  vpc_id      = aws_vpc.mgmt_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1 # the ICMP type number for 'Echo Reply'
    to_port     = -1 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "NSG-mgmt-ssh-icmp-https"
    scenario = var.scenario
  }
}

resource "aws_security_group" "NSG-vpc-sec-ssh-icmp-https" {
  name        = "NSG-vpc-sec-ssh-icmp-https"
  description = "Allow SSH, HTTPS and ICMP traffic"
  vpc_id      = aws_vpc.vpc_sec.id

  ingress {
    description = "Allow remote access to FGT"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "NSG-vpc-sec-ssh-icmp-https"
    scenario = var.scenario
  }
}



# Create all the eni interfaces
resource "aws_network_interface" "eni-fgt1-private" {
  subnet_id         = aws_subnet.private_subnet1.id
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt1-eniprivate"
  }
}

resource "aws_network_interface" "eni-fgt2-private" {
  subnet_id         = aws_subnet.private_subnet2.id
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt2-eniprivate"
  }
}

resource "aws_network_interface" "eni-fgt1-public" {
  subnet_id         = aws_subnet.public_subnet1.id
  private_ips       = ["10.0.1.100"]
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt1-enipublic"
  }
}

resource "aws_network_interface" "eni-fgt2-public" {
  subnet_id         = aws_subnet.public_subnet2.id
  private_ips       = ["10.0.10.100"]
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt2-enipublic"
  }
}

resource "aws_network_interface" "eni-fgt1-hb" {
  subnet_id         = aws_subnet.heartbeat_subnet1.id
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  private_ips       = [cidrhost(var.security_vpc_heartbeat_subnet_cidr1, 10)]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt1-enihb"
  }
}

resource "aws_network_interface" "eni-fgt2-hb" {
  subnet_id         = aws_subnet.heartbeat_subnet2.id
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  private_ips       = [cidrhost(var.security_vpc_heartbeat_subnet_cidr2, 10)]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt2-enihb"
  }
}

resource "aws_network_interface" "eni-fgt1-mgmt" {
  subnet_id         = aws_subnet.mgmt_subnet1.id
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt1-enimgmt"
  }
}

resource "aws_network_interface" "eni-fgt2-mgmt" {
  subnet_id         = aws_subnet.mgmt_subnet2.id
  security_groups   = [aws_security_group.NSG-vpc-sec-ssh-icmp-https.id]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt2-enimgmt"
  }
}

# Create and attach the eip to the units
resource "aws_eip" "eip-mgmt1" {
  depends_on        = [aws_instance.fgt1]
  vpc               = true
  network_interface = aws_network_interface.eni-fgt1-mgmt.id
  tags = {
    Name = "${var.tag_name_prefix}-fgt1-eip-mgmt"
  }
}

resource "aws_eip" "eip-mgmt2" {
  depends_on        = [aws_instance.fgt2]
  vpc               = true
  network_interface = aws_network_interface.eni-fgt2-mgmt.id
  tags = {
    Name = "${var.tag_name_prefix}-fgt2-eip-mgmt"
  }
}

resource "aws_eip" "eip-shared" {
  depends_on        = [aws_instance.fgt1]
  vpc               = true
  network_interface = aws_network_interface.eni-fgt1-public.id
  tags = {
    Name = "${var.tag_name_prefix}-eip-cluster"
  }
}

# Create the instances
resource "aws_instance" "fgt1" {
  ami                  = var.license_type == "byol" ? var.fgtvmbyolami[var.region] : var.fgt-ond-amis[var.region]
  instance_type        = var.instance_type
  availability_zone    = var.availability_zone1
  key_name             = var.keypair
  user_data            = data.template_file.fgt_userdata1.rendered
  iam_instance_profile = "APICall_role"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni-fgt1-public.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.eni-fgt1-private.id
  }
  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.eni-fgt1-mgmt.id
  }
  network_interface {
    device_index         = 3
    network_interface_id = aws_network_interface.eni-fgt1-hb.id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-fgt1"
  }
}

resource "aws_instance" "fgt2" {
  ami                  = var.license_type == "byol" ? var.fgtvmbyolami[var.region] : var.fgt-ond-amis[var.region]
  instance_type        = var.instance_type
  availability_zone    = var.availability_zone2
  key_name             = var.keypair
  user_data            = data.template_file.fgt_userdata2.rendered
  iam_instance_profile = "APICall_role"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni-fgt2-public.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.eni-fgt2-private.id
  }
  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.eni-fgt2-mgmt.id
  }
  network_interface {
    device_index         = 3
    network_interface_id = aws_network_interface.eni-fgt2-hb.id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-fgt2"
  }
}



data "template_file" "fgt_userdata1" {
  template = file("./fgt-userdata.tpl")

  vars = {
    fgt_id               = "FGT-Active"
    type                 = "${var.license_type}"
    license_file         = "${var.license}"
    fgt_private_ip       = join("/", [element(tolist(aws_network_interface.eni-fgt1-private.private_ips), 0), cidrnetmask("${var.security_vpc_private_subnet_cidr1}")])
    fgt_public_ip        = join("/", [element(tolist(aws_network_interface.eni-fgt1-public.private_ips), 0), cidrnetmask("${var.security_vpc_public_subnet_cidr1}")])
    fgt_heartbeat_ip     = join("/", [element(tolist(aws_network_interface.eni-fgt1-hb.private_ips), 0), cidrnetmask("${var.security_vpc_heartbeat_subnet_cidr1}")])
    fgt_mgmt_ip          = join("/", [element(tolist(aws_network_interface.eni-fgt1-mgmt.private_ips), 0), cidrnetmask("${var.security_vpc_mgmt_subnet_cidr1}")])
    fgt1_public_eni      = var.fgt1_public_eni
    fqdn_nlb             = aws_lb.int-nlb.dns_name
    private_gw           = cidrhost(var.security_vpc_private_subnet_cidr1, 1)
    public_gw            = cidrhost(var.security_vpc_public_subnet_cidr1, 1)
    az1_nlb              = var.az1_nlb
    az2_nlb              = var.az2_nlb
    webvpc_cidr          = var.web_vpc_cidr
    appvpc_cidr          = var.app_vpc_cidr
    dbvpc_cidr           = var.db_vpc_cidr
    allvpc_cidr          = var.all_vpc_cidr
    mgmtvpc_cidr         = var.mgmt_vpc_cidr
    password             = var.password
    mgmt_gw              = cidrhost(var.security_vpc_mgmt_subnet_cidr1, 1)
    fgt_priority         = "255"
    fgt-remote-heartbeat = element(tolist(aws_network_interface.eni-fgt2-hb.private_ips), 0)
  }
}

data "template_file" "fgt_userdata2" {
  template = file("./fgt-userdata.tpl")

  vars = {
    fgt_id               = "FGT-Passive"
    type                 = "${var.license_type}"
    license_file         = "${var.license2}"
    fgt_private_ip       = join("/", [element(tolist(aws_network_interface.eni-fgt2-private.private_ips), 0), cidrnetmask("${var.security_vpc_private_subnet_cidr2}")])
    fgt_public_ip        = join("/", [element(tolist(aws_network_interface.eni-fgt2-public.private_ips), 0), cidrnetmask("${var.security_vpc_public_subnet_cidr2}")])    
    fgt_heartbeat_ip     = join("/", [element(tolist(aws_network_interface.eni-fgt2-hb.private_ips), 0), cidrnetmask("${var.security_vpc_heartbeat_subnet_cidr2}")])
    fgt_mgmt_ip          = join("/", [element(tolist(aws_network_interface.eni-fgt2-mgmt.private_ips), 0), cidrnetmask("${var.security_vpc_mgmt_subnet_cidr2}")])
    public_gw            = cidrhost(var.security_vpc_public_subnet_cidr2, 1)
    private_gw           = cidrhost(var.security_vpc_private_subnet_cidr2, 1)
    az1_nlb              = var.az1_nlb
    az2_nlb              = var.az2_nlb
    fqdn_nlb             = aws_lb.int-nlb.dns_name
    fgt1_public_eni      = var.fgt2_public_eni
    webvpc_cidr          = var.web_vpc_cidr
    appvpc_cidr          = var.app_vpc_cidr
    dbvpc_cidr           = var.db_vpc_cidr   
    mgmtvpc_cidr         = var.mgmt_vpc_cidr
    allvpc_cidr          = var.all_vpc_cidr
    password             = var.password
    mgmt_gw              = cidrhost(var.security_vpc_mgmt_subnet_cidr2, 1)
    fgt_priority         = "100"
    fgt-remote-heartbeat = element(tolist(aws_network_interface.eni-fgt1-hb.private_ips), 0)
  }
}
