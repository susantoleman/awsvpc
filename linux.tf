##############################################################################################################
# VM LINUX for testing
##############################################################################################################
## Retrieve AMI info
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# test device in web

resource "aws_network_interface" "eni-instance-web" {
  subnet_id   = aws_subnet.web_vpc-priv1.id
  private_ips = ["10.1.1.100"]
  security_groups = [aws_security_group.NSG-webvpc-ssh-icmp-https.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "instance-web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
#  subnet_id              = aws_subnet.web_vpc-priv1.id
#  vpc_security_group_ids = [aws_security_group.NSG-webvpc-ssh-icmp-https.id]
  key_name               = var.keypair
  network_interface {
    network_interface_id = aws_network_interface.eni-instance-web.id
    device_index         = 0
  }
  tags = {
    Name     = "web"
    scenario = var.scenario
    az       = var.availability_zone1
    server   = "web"
  }
}


resource "aws_network_interface" "eni-instance-web2" {
  subnet_id   = aws_subnet.web_vpc-priv2.id
  private_ips = ["10.1.10.100"]
  security_groups = [aws_security_group.NSG-webvpc-ssh-icmp-https.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "instance-web2" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
#  subnet_id              = aws_subnet.web_vpc-priv2.id
#  vpc_security_group_ids = [aws_security_group.NSG-webvpc-ssh-icmp-https.id]
  key_name                = var.keypair
  network_interface {
    network_interface_id = aws_network_interface.eni-instance-web2.id
    device_index         = 0
  }
  tags = {
    Name     = "web2"
    scenario = var.scenario
    az       = var.availability_zone2
    server   = "web"
  }
}

# test device in app

resource "aws_network_interface" "eni-instance-app" {
  subnet_id   = aws_subnet.app_vpc-priv1.id
  private_ips = ["10.2.1.100"]
  security_groups = [aws_security_group.NSG-appvpc-ssh-icmp-https.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "instance-app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
 # subnet_id              = aws_subnet.app_vpc-priv1.id
 # vpc_security_group_ids = [aws_security_group.NSG-appvpc-ssh-icmp-https.id]
  key_name               = var.keypair
  network_interface {
    network_interface_id = aws_network_interface.eni-instance-app.id
    device_index         = 0
  }
  tags = {
    Name     = "app"
    scenario = var.scenario
    az       = var.availability_zone1
    server = "app"
  }
}

# test device in db


resource "aws_network_interface" "eni-instance-db" {
  subnet_id   = aws_subnet.db_vpc-priv1.id
  private_ips = ["10.3.1.100"]
  security_groups = [aws_security_group.NSG-dbvpc-ssh-icmp-https.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "instance-db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
#  subnet_id              = aws_subnet.db_vpc-priv1.id
#  vpc_security_group_ids = [aws_security_group.NSG-dbvpc-ssh-icmp-https.id]
  key_name               = var.keypair
  network_interface {
    network_interface_id = aws_network_interface.eni-instance-db.id
    device_index         = 0
  }
  tags = {
    Name     = "db"
    scenario = var.scenario
    az       = var.availability_zone1
    server = "db"
  }
}


# test device in mgmt

resource "aws_instance" "instance-mgmt" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.mgmt-priv1.id
  vpc_security_group_ids      = [aws_security_group.NSG-mgmt-ssh-icmp-https.id]
  key_name                    = var.keypair
  associate_public_ip_address = true

  tags = {
    Name     = "instance-${var.tag_name_unique}-mgmt"
    scenario = var.scenario
    az       = var.availability_zone1
    server = "mgmt"
  }
}


