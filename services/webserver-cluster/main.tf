resource "aws_instance" "example" {
  ami                    = "ami-40d28157"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  key_name               = "ecskeypair"
  user_data              = "${data.template_file.user_data.rendered}"

  tags {
    Name = "${var.cluster_name}-terraform-example"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    db_port     = "${data.terraform_remote_state.db.port}"
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
}

resource "aws_security_group_rule" "instanceport" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"
  from_port         = "${var.server_port}"
  to_port           = "${var.server_port}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

// reffering to mysql remote state file for getting mysql address and port :
data "terraform_remote_state" "db" {
  backend = "s3"

  config {
    bucket = "${var.db_remote_state_bucket}"
    key    = "${var.db_remote_state_key}"
    region = "us-east-1"
  }
}
