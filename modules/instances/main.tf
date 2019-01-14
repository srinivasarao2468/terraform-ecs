data "aws_ami" "server_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

data "template_file" "user-init" {
  template = "${file("${path.module}/userdata1.tpl")}"
}

resource "aws_instance" "jenkins_master" {
  count                  = "${var.jenkins_master_count}"
  instance_type          = "${var.instance_type}"
  ami                    = "${data.aws_ami.server_ami.id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  subnet_id              = "${element(var.subnets, count.index)}"
  user_data              = "${data.template_file.user-init.rendered}"

  tags {
    Name = "jenkins_master-${count.index +1}"
  }
}

data "template_file" "user-init1" {
  template = "${file("${path.module}/userdata2.tpl")}"
}

resource "aws_instance" "jenkins_slave" {
  count                  = "${var.jenkins_slave_count}"
  instance_type          = "${var.instance_type}"
  ami                    = "${data.aws_ami.server_ami.id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  subnet_id              = "${element(var.subnets, count.index)}"
  user_data              = "${data.template_file.user-init1.rendered}"

  tags {
    Name = "jenkins_slave-${count.index +1}"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
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
}
