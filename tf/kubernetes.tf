output "cluster_name" {
  value = "k8s.dshmelev.net"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-k8s-dshmelev-net.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-k8s-dshmelev-net.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-k8s-dshmelev-net.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-k8s-dshmelev-net.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-west-2a-k8s-dshmelev-net.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-k8s-dshmelev-net.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-k8s-dshmelev-net.name}"
}

output "region" {
  value = "us-west-2"
}

output "vpc_id" {
  value = "${aws_vpc.k8s-dshmelev-net.id}"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_autoscaling_group" "master-us-west-2a-masters-k8s-dshmelev-net" {
  name                 = "master-us-west-2a.masters.k8s.dshmelev.net"
  launch_configuration = "${aws_launch_configuration.master-us-west-2a-masters-k8s-dshmelev-net.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-west-2a-k8s-dshmelev-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "k8s.dshmelev.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-west-2a.masters.k8s.dshmelev.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-k8s-dshmelev-net" {
  name                 = "nodes.k8s.dshmelev.net"
  launch_configuration = "${aws_launch_configuration.nodes-k8s-dshmelev-net.id}"
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-west-2a-k8s-dshmelev-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "k8s.dshmelev.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.k8s.dshmelev.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-k8s-dshmelev-net" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s.dshmelev.net"
    Name                 = "a.etcd-events.k8s.dshmelev.net"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-k8s-dshmelev-net" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s.dshmelev.net"
    Name                 = "a.etcd-main.k8s.dshmelev.net"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-k8s-dshmelev-net" {
  name = "masters.k8s.dshmelev.net"
  role = "${aws_iam_role.masters-k8s-dshmelev-net.name}"
}

resource "aws_iam_instance_profile" "nodes-k8s-dshmelev-net" {
  name = "nodes.k8s.dshmelev.net"
  role = "${aws_iam_role.nodes-k8s-dshmelev-net.name}"
}

resource "aws_iam_role" "masters-k8s-dshmelev-net" {
  name               = "masters.k8s.dshmelev.net"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.k8s.dshmelev.net_policy")}"
}

resource "aws_iam_role" "nodes-k8s-dshmelev-net" {
  name               = "nodes.k8s.dshmelev.net"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.k8s.dshmelev.net_policy")}"
}

resource "aws_iam_role_policy" "masters-k8s-dshmelev-net" {
  name   = "masters.k8s.dshmelev.net"
  role   = "${aws_iam_role.masters-k8s-dshmelev-net.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.k8s.dshmelev.net_policy")}"
}

resource "aws_iam_role_policy" "nodes-k8s-dshmelev-net" {
  name   = "nodes.k8s.dshmelev.net"
  role   = "${aws_iam_role.nodes-k8s-dshmelev-net.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.k8s.dshmelev.net_policy")}"
}

resource "aws_internet_gateway" "k8s-dshmelev-net" {
  vpc_id = "${aws_vpc.k8s-dshmelev-net.id}"

  tags = {
    KubernetesCluster = "k8s.dshmelev.net"
    Name              = "k8s.dshmelev.net"
  }
}

resource "aws_key_pair" "kubernetes-k8s-dshmelev-net-0a3bb97b55cb3871af607ed429d1a02e" {
  key_name   = "kubernetes.k8s.dshmelev.net-0a:3b:b9:7b:55:cb:38:71:af:60:7e:d4:29:d1:a0:2e"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.k8s.dshmelev.net-0a3bb97b55cb3871af607ed429d1a02e_public_key")}"
}

resource "aws_launch_configuration" "master-us-west-2a-masters-k8s-dshmelev-net" {
  name_prefix                 = "master-us-west-2a.masters.k8s.dshmelev.net-"
  image_id                    = "ami-ac58c0cc"
  instance_type               = "m3.medium"
  key_name                    = "${aws_key_pair.kubernetes-k8s-dshmelev-net-0a3bb97b55cb3871af607ed429d1a02e.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-k8s-dshmelev-net.id}"
  security_groups             = ["${aws_security_group.masters-k8s-dshmelev-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2a.masters.k8s.dshmelev.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-k8s-dshmelev-net" {
  name_prefix                 = "nodes.k8s.dshmelev.net-"
  image_id                    = "ami-ac58c0cc"
  instance_type               = "t2.small"
  key_name                    = "${aws_key_pair.kubernetes-k8s-dshmelev-net-0a3bb97b55cb3871af607ed429d1a02e.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-k8s-dshmelev-net.id}"
  security_groups             = ["${aws_security_group.nodes-k8s-dshmelev-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.k8s.dshmelev.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.k8s-dshmelev-net.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.k8s-dshmelev-net.id}"
}

resource "aws_route_table" "k8s-dshmelev-net" {
  vpc_id = "${aws_vpc.k8s-dshmelev-net.id}"

  tags = {
    KubernetesCluster = "k8s.dshmelev.net"
    Name              = "k8s.dshmelev.net"
  }
}

resource "aws_route_table_association" "us-west-2a-k8s-dshmelev-net" {
  subnet_id      = "${aws_subnet.us-west-2a-k8s-dshmelev-net.id}"
  route_table_id = "${aws_route_table.k8s-dshmelev-net.id}"
}

resource "aws_security_group" "masters-k8s-dshmelev-net" {
  name        = "masters.k8s.dshmelev.net"
  vpc_id      = "${aws_vpc.k8s-dshmelev-net.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "k8s.dshmelev.net"
    Name              = "masters.k8s.dshmelev.net"
  }
}

resource "aws_security_group" "nodes-k8s-dshmelev-net" {
  name        = "nodes.k8s.dshmelev.net"
  vpc_id      = "${aws_vpc.k8s-dshmelev-net.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "k8s.dshmelev.net"
    Name              = "nodes.k8s.dshmelev.net"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  from_port                = 1
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-k8s-dshmelev-net.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-k8s-dshmelev-net.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-west-2a-k8s-dshmelev-net" {
  vpc_id            = "${aws_vpc.k8s-dshmelev-net.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-west-2a"

  tags = {
    KubernetesCluster                        = "k8s.dshmelev.net"
    Name                                     = "us-west-2a.k8s.dshmelev.net"
    "kubernetes.io/cluster/k8s.dshmelev.net" = "owned"
  }
}

resource "aws_vpc" "k8s-dshmelev-net" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                        = "k8s.dshmelev.net"
    Name                                     = "k8s.dshmelev.net"
    "kubernetes.io/cluster/k8s.dshmelev.net" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "k8s-dshmelev-net" {
  domain_name         = "us-west-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "k8s.dshmelev.net"
    Name              = "k8s.dshmelev.net"
  }
}

resource "aws_vpc_dhcp_options_association" "k8s-dshmelev-net" {
  vpc_id          = "${aws_vpc.k8s-dshmelev-net.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.k8s-dshmelev-net.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
