variable "ansible_host" {
  type        = string
  description = "Ansible server IP or host name"
}
variable "ansible_password" {
  type        = string
  description = "Ansible Server root password"
}

variable "vsphere_user" {
  type = string
  description = "the username for vsphere"
}
variable "vsphere_password" {
  type = string
  description = "The password for vsphere"
}
variable "vsphere_server" {
  type = string
  description = "the hostname or ip address of your vcenter server"
}

variable "vsphere_datacenter" {
  type = string
  description = "the name of the datacenter"
}

variable "vsphere_datastore" {
  type = string
  description = "the name of the datastore"
}

variable "vsphere_vm_template" {
  type = string
  description = "the name of the vm template"
}

variable "vsphere_vm_name_1" {
  type = string
  description = "the name of the vm"
}

variable "vsphere_vm_name_2" {
  type = string
  description = "the name of the vm"
}

variable "vsphere_resource_pool" {
  type = string
  description = "the name of the resourcepool for examples: Cluster1/Resources " 
}

variable "vsphere_vm_portgroup" {
  type = string
  description = "the name of the portgroup"
}

variable "vsphere_vm_cpu" {
  type = number
  description = "the number of vCpus"
  default = 2
}

variable "vsphere_vm_memory" {
  type = number
  description = "the amount of memory in MB"
  default = 2048
}

variable "vsphere_vm_guest" {
  type = string
  description = "the name of the os type "
  default = "ubuntu64Guest"
}

variable "vsphere_vm_disksize" {
  type = number
  description = "the size of the disk in GB"
  default = 20
}

variable "timeout" {
  description = "The timeout, in minutes, to wait for the virtual machine clone to complete."
  type        = number
  default     = 30
}

variable "linked_clone" {
  description = "Clone this virtual machine from a snapshot. Templates must have a single snapshot only in order to be eligible."
  default     = false
}
