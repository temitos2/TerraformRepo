/*
  Database Servers
*/
resource "aws_security_group" "db" {
  name        = "vpc_db"
  description = "Allow incoming database connections."

  ingress {
    from_port   = 3306          # MySQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "DBServerSG"
  }
}

resource "aws_instance" "db-1" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  subnet_id              = "${aws_subnet.private_subnet.id}"
  user_data              = "${file("db.sh")}"
  source_dest_check      = false

  tags {
    Name = "DB Server 1"
  }
   depends_on = ["aws_nat_gateway.gw"]
}
