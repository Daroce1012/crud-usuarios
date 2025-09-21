# Configuración súper simple - Solo lo esencial

# Backend Server
resource "openstack_compute_instance_v2" "backend" {
  name            = "crud-backend"
  image_id        = data.openstack_images_image_v2.ubuntu_image.id
  flavor_id       = data.openstack_compute_flavor_v2.medium.id
  key_pair        = openstack_compute_keypair_v2.crud_keypair.name
  security_groups = [openstack_networking_secgroup_v2.backend_sg.name]

  network {
    name = data.openstack_networking_network_v2.student_network.name
  }

  user_data = <<-EOF
    #cloud-config
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh-authorized-keys:
          - ${openstack_compute_keypair_v2.crud_keypair.public_key}
    
    ssh_pwauth: false
    package_update: true
    packages:
      - python3
      - python3-pip
    
    runcmd:
      - apt-get update
      - pip3 install flask flask-cors
      - echo "Backend listo" > /home/ubuntu/backend-info.txt
  EOF

  metadata = {
    role = "backend"
  }
}

# Frontend Server
resource "openstack_compute_instance_v2" "frontend" {
  name            = "crud-frontend"
  image_id        = data.openstack_images_image_v2.ubuntu_image.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  key_pair        = openstack_compute_keypair_v2.crud_keypair.name
  security_groups = [openstack_networking_secgroup_v2.frontend_sg.name]

  network {
    name = data.openstack_networking_network_v2.student_network.name
  }

  user_data = <<-EOF
    #cloud-config
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh-authorized-keys:
          - ${openstack_compute_keypair_v2.crud_keypair.public_key}
    
    ssh_pwauth: false
    package_update: true
    packages:
      - apache2
    
    runcmd:
      - apt-get update
      - a2enmod proxy proxy_http
      - systemctl restart apache2
      - echo "Frontend listo" > /var/www/html/index.html
  EOF

  metadata = {
    role = "frontend"
  }
}

# Load Balancer eliminado - solo Backend + Frontend por ahora