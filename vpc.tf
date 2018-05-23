provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "terraform-aws-vpc"
  }
}

/*
  Public Subnet
*/
resource "aws_subnet" "public-subnet" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"

  tags {
    Name = "Public Subnet"
  }
}

/*
  Private Subnet
*/
resource "aws_subnet" "private_subnet" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"

  tags {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_default_route_table" "default_routing" {
  default_route_table_id = "${aws_vpc.default.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_eip" "nat" {
  //  instance = "${aws_instance.nat.id}"
    vpc = true
}
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
}



# Define the route for public table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}



# Define the route for private table
resource "aws_route_table" "db-private-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "Private Subnet RT"
  }
}

# Assign the route table to the private Subnet
resource "aws_route_table_association" "db-private-rt" {
  subnet_id = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.db-private-rt.id}"
}
