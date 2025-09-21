# Obtener el puerto de la instancia frontend
data "openstack_networking_port_v2" "frontend_port" {
  fixed_ip = openstack_compute_instance_v2.frontend.access_ip_v4
}

# Usar la IP flotante existente para el frontend (para ver la web)
resource "openstack_networking_floatingip_associate_v2" "frontend_floating_ip" {
  floating_ip = "156.35.98.122"
  port_id     = data.openstack_networking_port_v2.frontend_port.id
}
