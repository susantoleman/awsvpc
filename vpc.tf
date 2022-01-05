##############################################################################################################
# VPC SECURITY
##############################################################################################################
resource "aws_vpc" "vpc_sec" {
  cidr_block           = var.security_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.tag_name_prefix}-vpc_sec"
  }
}

# IGW
resource "aws_internet_gateway" "igw_sec" {
  vpc_id = aws_vpc.vpc_sec.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-igw_sec"
  }
}

# Subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_private_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_private_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet2"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_public_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_public_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-subnet2"
  }
}

resource "aws_subnet" "tgw_subnet1" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_tgw_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgw-subnet1"
  }
}

resource "aws_subnet" "tgw_subnet2" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_tgw_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgw-subnet2"
  }
}

resource "aws_subnet" "heartbeat_subnet1" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_heartbeat_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-heartbeat-subnet1"
  }
}

resource "aws_subnet" "heartbeat_subnet2" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_heartbeat_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-heartbeat-subnet2"
  }
}

resource "aws_subnet" "mgmt_subnet1" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_mgmt_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-mgmt-subnet1"
  }
}

resource "aws_subnet" "mgmt_subnet2" {
  vpc_id            = aws_vpc.vpc_sec.id
  cidr_block        = var.security_vpc_mgmt_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-mgmt-subnet2"
  }
}

# Routes
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_sec.id
  route {
    cidr_block         = var.web_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }
  route {
    cidr_block         = var.app_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }
  route {
    cidr_block         = var.db_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }

  route {
    cidr_block         = var.mgmt_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }

  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-rt"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_sec.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_sec.id
  }
  tags = {
  Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-mgmt-rt"
  }
}

resource "aws_route_table" "tgw_rt" {
  vpc_id = aws_vpc.vpc_sec.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.eni-fgt1-private.id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgw-rt"
  }
}

resource "aws_route_table" "heartbeat_rt" {
  vpc_id = aws_vpc.vpc_sec.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-heartbeat-rt"
  }
}

# Route tables associations
resource "aws_route_table_association" "private_rt_association1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_rt_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "tgw_rt_association1" {
  subnet_id      = aws_subnet.tgw_subnet1.id
  route_table_id = aws_route_table.tgw_rt.id
}

resource "aws_route_table_association" "tgw_rt_association2" {
  subnet_id      = aws_subnet.tgw_subnet2.id
  route_table_id = aws_route_table.tgw_rt.id
}

resource "aws_route_table_association" "mgmt_rt_association1" {
  subnet_id      = aws_subnet.mgmt_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "mgmt_rt_association2" {
  subnet_id      = aws_subnet.mgmt_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-sec" {
  subnet_ids                                      = [aws_subnet.tgw_subnet1.id, aws_subnet.tgw_subnet2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-XAZ.id
  vpc_id                                          = aws_vpc.vpc_sec.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name     = "tgw-att-vpc_sec"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

#############################################################################################################
# VPC web
#############################################################################################################
resource "aws_vpc" "web_vpc" {
  cidr_block = var.web_vpc_cidr

  tags = {
    Name     = "${var.tag_name_prefix}-vpc-web"
    scenario = var.scenario
  }
}

# Subnets
resource "aws_subnet" "web_vpc-priv1" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = var.web_vpc_private_subnet_cidr1
  availability_zone = var.availability_zone1

  tags = {
    Name = "${aws_vpc.web_vpc.tags.Name}-priv1"
  }
}

resource "aws_subnet" "web_vpc-priv2" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = var.web_vpc_private_subnet_cidr2
  availability_zone = var.availability_zone2

  tags = {
    Name = "${aws_vpc.web_vpc.tags.Name}-priv2"
  }
}

# Routes
resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }

  tags = {
    Name     = "web-vpc-rt"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

# Route tables associations
resource "aws_route_table_association" "web_rt_association1" {
  subnet_id      = aws_subnet.web_vpc-priv1.id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_route_table_association" "web_rt_association2" {
  subnet_id      = aws_subnet.web_vpc-priv2.id
  route_table_id = aws_route_table.web-rt.id
}

# Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-web-vpc" {
  subnet_ids                                      = [aws_subnet.web_vpc-priv1.id, aws_subnet.web_vpc-priv2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-XAZ.id
  vpc_id                                          = aws_vpc.web_vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name     = "tgw-att-web-vpc"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

#############################################################################################################
# VPC app
#############################################################################################################
resource "aws_vpc" "app_vpc" {
  cidr_block = var.app_vpc_cidr

  tags = {
    Name     = "${var.tag_name_prefix}-vpc-app"
    scenario = var.scenario
  }
}

# Subnets
resource "aws_subnet" "app_vpc-priv1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.app_vpc_private_subnet_cidr1
  availability_zone = var.availability_zone1

  tags = {
    Name = "${aws_vpc.app_vpc.tags.Name}-priv1"
  }
}

resource "aws_subnet" "app_vpc-priv2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.app_vpc_private_subnet_cidr2
  availability_zone = var.availability_zone2

  tags = {
    Name = "${aws_vpc.app_vpc.tags.Name}-priv2"
  }
}

# Routes
resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }

  tags = {
    Name     = "app-vpc-rt"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

# Route tables associations
resource "aws_route_table_association" "app_rt_association1" {
  subnet_id      = aws_subnet.app_vpc-priv1.id
  route_table_id = aws_route_table.app-rt.id
}

resource "aws_route_table_association" "app_rt_association2" {
  subnet_id      = aws_subnet.app_vpc-priv2.id
  route_table_id = aws_route_table.app-rt.id
}

# Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-app-vpc" {
  subnet_ids                                      = [aws_subnet.app_vpc-priv1.id, aws_subnet.app_vpc-priv2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-XAZ.id
  vpc_id                                          = aws_vpc.app_vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name     = "tgw-att-app-vpc"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

#############################################################################################################
# VPC db
#############################################################################################################
resource "aws_vpc" "db_vpc" {
  cidr_block = var.db_vpc_cidr

  tags = {
    Name     = "${var.tag_name_prefix}-vpc-db"
    scenario = var.scenario
  }
}

# Subnets
resource "aws_subnet" "db_vpc-priv1" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.db_vpc_private_subnet_cidr1
  availability_zone = var.availability_zone1

  tags = {
    Name = "${aws_vpc.db_vpc.tags.Name}-priv1"
  }
}

resource "aws_subnet" "db_vpc-priv2" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.db_vpc_private_subnet_cidr2
  availability_zone = var.availability_zone2

  tags = {
    Name = "${aws_vpc.db_vpc.tags.Name}-priv2"
  }
}

# Routes
resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.db_vpc.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }

  tags = {
    Name     = "app-db-rt"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

# Route tables associations
resource "aws_route_table_association" "db_rt_association1" {
  subnet_id      = aws_subnet.db_vpc-priv1.id
  route_table_id = aws_route_table.db-rt.id
}

resource "aws_route_table_association" "db_rt_association2" {
  subnet_id      = aws_subnet.db_vpc-priv2.id
  route_table_id = aws_route_table.db-rt.id
}

# Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-db-vpc" {
  subnet_ids                                      = [aws_subnet.db_vpc-priv1.id, aws_subnet.db_vpc-priv2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-XAZ.id
  vpc_id                                          = aws_vpc.db_vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name     = "tgw-att-db-vpc"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

#############################################################################################################
# VPC MGMT
#############################################################################################################
resource "aws_vpc" "mgmt_vpc" {
  cidr_block = var.mgmt_vpc_cidr

  tags = {
    Name     = "${var.tag_name_prefix}-vpc-mgmt"
    scenario = var.scenario
  }
}

# IGW
resource "aws_internet_gateway" "igw_mgmt" {
  vpc_id = aws_vpc.mgmt_vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-igw_mgmt"
  }
}

# Subnets
resource "aws_subnet" "mgmt-priv1" {
  vpc_id            = aws_vpc.mgmt_vpc.id
  cidr_block        = var.mgmt_private_subnet_cidr1
  availability_zone = var.availability_zone1

  tags = {
    Name = "${aws_vpc.mgmt_vpc.tags.Name}-priv1"
  }
}

resource "aws_subnet" "mgmt-priv2" {
  vpc_id            = aws_vpc.mgmt_vpc.id
  cidr_block        = var.mgmt_private_subnet_cidr2
  availability_zone = var.availability_zone2

  tags = {
    Name = "${aws_vpc.mgmt_vpc.tags.Name}-priv2"
  }
}

# Routes
resource "aws_route_table" "mgmt-rt" {
  vpc_id = aws_vpc.mgmt_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_mgmt.id
  }
  route {
    cidr_block         = var.app_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }
  route {
    cidr_block         = var.web_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }
  route {
    cidr_block         = var.db_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.TGW-XAZ.id
  }
  tags = {
    Name     = "mgmt-rt"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}

# Route tables associations
resource "aws_route_table_association" "mgmtvpc_rt_association1" {
  subnet_id      = aws_subnet.mgmt-priv1.id
  route_table_id = aws_route_table.mgmt-rt.id
}

resource "aws_route_table_association" "mgmtvpc_rt_association2" {
  subnet_id      = aws_subnet.mgmt-priv2.id
  route_table_id = aws_route_table.mgmt-rt.id
}

# Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-mgmt" {
  subnet_ids                                      = [aws_subnet.mgmt-priv1.id, aws_subnet.mgmt-priv2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-XAZ.id
  vpc_id                                          = aws_vpc.mgmt_vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name     = "tgw-att-mgmt"
    scenario = var.scenario
  }
  depends_on = [aws_ec2_transit_gateway.TGW-XAZ]
}