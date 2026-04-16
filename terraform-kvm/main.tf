terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# 1. On définit d'abord l'image source (en lecture seule)
resource "libvirt_volume" "base_image" {
  name   = "ubuntu-source-template"
  pool   = "default"
  source = "/var/lib/libvirt/images/ubuntu.qcow2"
  format = "qcow2"
}

# 2. On crée le volume de la VM basé sur la source MAIS avec 10 Go
resource "libvirt_volume" "os" {
  name           = "vm-os.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.base_image.id # On utilise l'image source comme base
  size           = 10737418240                  # 10 Go (en octets)
  format         = "qcow2"
}

# 3. La configuration Cloud-Init (Accès garanti)
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = "default"
  user_data = <<EOF
#cloud-config
ssh_pwauth: True
chpasswd:
  list: |
     ubuntu:ubuntu
  expire: False
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
EOF
}

# 4. La définition de la Machine Virtuelle
resource "libvirt_domain" "vm" {
  name   = "terraform-vm"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.os.id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}
