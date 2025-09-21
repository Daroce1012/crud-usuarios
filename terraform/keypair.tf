# Generar par de claves SSH para acceso a las instancias
resource "openstack_compute_keypair_v2" "crud_keypair" {
  name       = var.key_pair_name
  public_key = file("${path.module}/../id_rsa.pub")  # Clave pública en el directorio del proyecto
}
