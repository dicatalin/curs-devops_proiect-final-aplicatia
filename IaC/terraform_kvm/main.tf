terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

variable "vm_password" {
  type      = string
  sensitive = true
}

locals {
  vms = {
    prod-host = {
      cpu    = 2
      memory = 2048
    }
    stage-host = {
      cpu    = 2
      memory = 2048
    }
    automation-host = {
      cpu    = 2
      memory = 4096
    }
  }

  debian_image_url = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
  debian_image     = "debian-13.qcow2"
}

# descarcă imaginea
resource "null_resource" "download_image" {
  provisioner "local-exec" {
    command = "wget -nc ${local.debian_image_url} -O ${local.debian_image}"
  }
}

# volum base image
resource "libvirt_volume" "base_image" {
  name   = "debian-13-base.qcow2"
  pool   = "default"
  source = local.debian_image
  format = "qcow2"

  depends_on = [null_resource.download_image]
}

# disk pentru fiecare VM
resource "libvirt_volume" "vm_disk" {
  for_each       = local.vms
  name           = "${each.key}.qcow2"
  base_volume_id = libvirt_volume.base_image.id
  pool           = "default"
  size           = 21474836480
}

# cloud-init config
resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each = local.vms
  name     = "${each.key}-cloudinit.iso"
  pool     = "default"

  user_data = <<EOF
#cloud-config
hostname: ${each.key}

ssh_pwauth: true
disable_root: false

chpasswd:
  list: |
    debian:${var.vm_password}
  expire: false

packages:
  - qemu-guest-agent

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
EOF
}

# VM-urile
resource "libvirt_domain" "vm" {
  for_each = local.vms

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.cpu

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[each.key].id

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
  }
}

output "vm_ips" {
  value = {
    for vm_name, vm in libvirt_domain.vm :
    vm_name => vm.network_interface[0].addresses
  }
}