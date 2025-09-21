# Configuración del provider de OpenStack
terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 3.2.0"
    }
  }
}

# Configuración del provider OpenStack
provider "openstack" {
  auth_url    = var.openstack_auth_url
  user_name   = var.openstack_username
  password    = var.openstack_password
  domain_name = var.openstack_domain_name
  tenant_name = var.openstack_project_name
  region      = var.openstack_region
}

# Obtener información de la imagen
data "openstack_images_image_v2" "ubuntu_image" {
  name = "Ubuntu-24.04"
}

# Obtener información de los flavors
data "openstack_compute_flavor_v2" "small" {
  name = "m2_small_1"
}

data "openstack_compute_flavor_v2" "medium" {
  name = "m2_medium_2"
}

# Obtener información de la red interna
data "openstack_networking_network_v2" "student_network" {
  name = "networks_uo312167"
}

# Obtener información de la red externa (para el router)
data "openstack_networking_network_v2" "external_network" {
  external = true
}

# Obtener información de las subredes
data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  network_id = data.openstack_networking_network_v2.student_network.id
}

