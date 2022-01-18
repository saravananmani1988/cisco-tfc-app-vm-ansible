terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "1.24.3"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # if you have a self-signed cert
  allow_unverified_ssl = true
}


data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_vm_portgroup
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "vm-web" {
  name             = "vm-web"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = "3"
  memory   = "2048"
  guest_id = "centos7_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = "25"
    thin_provisioned = false
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = "false"
    timeout       = "15"
	  
  customize {
      linux_options {
        host_name = "terraform-test-web"
        domain    = "stovl.ad"
      }

      network_interface {
        ipv4_address = "10.0.208.234"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.0.208.1"
    }

  }


}

resource "vsphere_virtual_machine" "vm-db" {
  name             = "vm-db"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = "3"
  memory   = "2048"
  guest_id = "centos7_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = "25"
    thin_provisioned = false
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = "false"
    timeout       = "15"

  customize {
      linux_options {
        host_name = "terraform-test-db"
        domain    = "stovl.ad"
      }
	  
     network_interface {
        ipv4_address = "10.0.208.235"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.0.208.1"
      dns_server_list = ["10.0.208.135","8.8.8.8"]
      dns_suffix_list = ["stovl.ad"]
    }

  }


}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait_180_seconds]
}


#connecting to the Linux OS having the Ansible playbook
resource "null_resource" "nullremote2" {
connection {
	type     = "ssh"
	user     = "root"
	password = "${var.ansible_password}"
    	host= "${var.ansible_host}"
}
#command to run ansible playbook on remote Linux OS
provisioner "remote-exec" {
    
    inline = [
	"cd /root/ansible_terraform/",
	"ansible-playbook ansible-playbook-vm.yml"
]
}
}
