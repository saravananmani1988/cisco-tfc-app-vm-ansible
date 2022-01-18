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
	"ansible-playbook-vm.yml"
]
}
}
