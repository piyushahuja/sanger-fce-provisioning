provider "openstack" {
   auth_url = "${var.openstack_auth_url}"
}


variable "openstack_key_pair" {
  default = "eta-hgi-keypair-ca6"
}

variable "openstack_auth_url" {
   default = "https://eta.internal.sanger.ac.uk:13000/v3"
}

variable "openstack_tenant_network" {
   default = "cloudforms_network"
}

variable "floating_ip" {
  default = "172.27.83.29"
}

variable "volume_id" {
  default = "bbc0daa2-897f-448e-95d0-e3fb16a388be"
}

variable "private_key_path" {
  default = "~/.ssh/clara.key"
}




resource "openstack_compute_instance_v2" "instance_name" {
  name = "eta-cellgen-ca6"
  image_name = "bionic-WTSI-docker_b5612"
  flavor_name = "m1.2xlarge"
  key_pair = "${var.openstack_key_pair}"
  security_groups = ["${openstack_compute_secgroup_v2.securitygroup_1.name}"]
  network {
      name = "${var.openstack_tenant_network}"

  }

  depends_on = [openstack_compute_secgroup_v2.securitygroup_1]

connection {
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    host = "${self.access_ip_v4}"
  }


# provisioner "remote-exec" {
  
#   inline = [
#       "echo"
#   ]
#   on_failure = "continue"

# }





# provisioner "local-exec" {

#     command = "ansible-playbook -i /Users/pa11/Code/fce_provisioning/ansible/inventory /Users/pa11/Code/fce_provisioning/ansible/playbook.yml "
#     on_failure = "continue"    
# }




}
resource "openstack_compute_volume_attach_v2" "eta-cellgen-ca6-volume" {
    instance_id = "${openstack_compute_instance_v2.instance_name.id}"
    volume_id = "${var.volume_id}"   
 }

resource "openstack_compute_secgroup_v2" "securitygroup_1" {
    name = "security_group_ca6"
    description = "allows ssh and http/https access to ports 80 and 22"

    rule {
        from_port = 80
        to_port = 80
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }

    rule {
        from_port = 22
        to_port =  22
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }
}

# resource "openstack_compute_floatingip_v2"  "floatingip_name" {
#     pool = "public"
# }

resource "openstack_compute_floatingip_associate_v2" "floatingip_name_associate" {
  floating_ip = "${var.floating_ip}"
  instance_id = "${openstack_compute_instance_v2.instance_name.id}"
  wait_until_associated = false
}




output "address" {
   value = "${var.floating_ip}"
}