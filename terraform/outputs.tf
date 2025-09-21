# Outputs simplificados

output "backend_ip" {
  description = "IP del Backend Server"
  value       = openstack_compute_instance_v2.backend.access_ip_v4
}

output "frontend_ip" {
  description = "IP del Frontend Server"
  value       = openstack_compute_instance_v2.frontend.access_ip_v4
}

output "backend_api_url" {
  description = "URL de la API Backend"
  value       = "http://${openstack_compute_instance_v2.backend.access_ip_v4}:5000"
}

output "frontend_floating_ip" {
  description = "IP flotante del Frontend para acceso web"
  value       = "156.35.98.122"
}

output "frontend_url" {
  description = "URL del Frontend"
  value       = "http://${openstack_compute_instance_v2.frontend.access_ip_v4}"
}

output "web_url" {
  description = "URL principal para acceder a la aplicación web"
  value       = "http://156.35.98.122"
}

output "ssh_commands" {
  description = "Comandos SSH para conectarse"
  value = {
    frontend = "ssh -i id_rsa ubuntu@156.35.98.122"
    backend = "ssh -i id_rsa ubuntu@${openstack_compute_instance_v2.backend.access_ip_v4} # Solo accesible desde frontend"
  }
}