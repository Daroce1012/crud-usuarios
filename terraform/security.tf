# Security Groups simplificados

# Security Group para Backend
resource "openstack_networking_secgroup_v2" "backend_sg" {
  name        = "crud-backend-sg"
  description = "Security group para Backend"
}

# Permitir SSH y API
resource "openstack_networking_secgroup_rule_v2" "backend_ssh" {
  direction         = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.backend_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "backend_api" {
  direction         = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 5000
  port_range_max   = 5000
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.backend_sg.id
}

# Security Group para Frontend
resource "openstack_networking_secgroup_v2" "frontend_sg" {
  name        = "crud-frontend-sg"
  description = "Security group para Frontend"
}

resource "openstack_networking_secgroup_rule_v2" "frontend_ssh" {
  direction         = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.frontend_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "frontend_http" {
  direction         = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.frontend_sg.id
}

# Load Balancer security group eliminado