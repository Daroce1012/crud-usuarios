# Variables para la configuración de OpenStack
variable "openstack_auth_url" {
  description = "URL de autenticación de OpenStack"
  type        = string
  default     = "http://156.35.95.8:5000/v3"
}

variable "openstack_username" {
  description = "Usuario de OpenStack"
  type        = string
  default     = "uo312167"
}

variable "openstack_password" {
  description = "Contraseña de OpenStack"
  type        = string
  default     = "Zn9YM$8wCW"
  sensitive   = true
}

variable "openstack_domain_name" {
  description = "Nombre del dominio en OpenStack"
  type        = string
  default     = "Default"
}

variable "openstack_project_name" {
  description = "Nombre del proyecto en OpenStack"
  type        = string
  default     = "proyecto_uo312167"
}

variable "openstack_region" {
  description = "Región de OpenStack"
  type        = string
  default     = "RegionOne"
}

# Variables para la infraestructura
variable "key_pair_name" {
  description = "Nombre del par de claves SSH"
  type        = string
  default     = "crud-keypair"
}

# Variable eliminada - ahora usamos flavors específicos en main.tf

variable "image_name" {
  description = "Nombre de la imagen base"
  type        = string
  default     = "Ubuntu-24.04"
}
