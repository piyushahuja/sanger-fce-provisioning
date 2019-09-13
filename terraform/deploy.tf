





provider "openstack" {

   # user_name = "${var.openstack_user_name}"
   auth_url = "${var.openstack_auth_url}"
   # tenant_name = "${var.openstack_tenant_name}"
   # key = "${var.ssh_key_file}"
   # password = "${var.openstack_user_password}"

}




# variable "openstack_user_name" {
#    # default = "pa11"
# }

# variable "openstack_tenant_name" {
#    # default = "hgi-ci"
# }

# variable "openstack_user_password" {
#   # default = "Piyush260790@sanger"
# }

variable "openstack_key_pair" {
  default = "eta-hgi-keypair-pa11"
}

variable "openstack_auth_url" {
   default = "https://eta.internal.sanger.ac.uk:13000/v3"
}

variable "openstack_tenant_network" {
   default = "cloudforms_network"
}

variable "private_key_path" {
  default = "/Users/pa11/.ssh/id_rsa"
}

# variable "private_key" {
 
 
# }



resource "openstack_compute_instance_v2" "instance_name" {
  name = "basic"
  image_name = "bionic-WTSI-docker_b5612"
  flavor_name = "m1.tiny"
  key_pair = "${var.openstack_key_pair}"
  security_groups = ["security_group1"]
  network {
      name = "${var.openstack_tenant_network}"


  }


provisioner "local-exec" {

    command = "ansible -i /Users/pa11/Code/clara_provisioning/ansible/inventory -u ubuntu  172.27.84.112 -m ping"
    on_failure = "fail"
  #         ls /dev/disk/by-id/ | 
  #         mkfs.ext4 /dev/disk/by-id/virtio-15a9f901-ba9d-45e1-8
  #       mkdir -p /mnt/volume
  # mount /dev/disk/by-id/virtio-87f5f27d-43f1-40ba-8 /home/ubuntu/mnt/volume         chmod 777 mnt/volume/

    
}

# provisioner "remote-exec" {
#   inline = [
#       "echo"
#   ]


#   connection {
#     user = "pa11"
#     private_key = "${file(var.private_key_path)}"
#     # host = "${openstack_compute_floatingip_v2.floatingip_name.address}"
#   }
 
# }



  

# metadata = {

  # }


    # "sudo apt-get -y update"
        # "sudo apt-get -y install nginx"
        # "sudo apt-get nginx start"
    # pass a script file which runs docker. "sudo docker run imagename"
  # block_device {
  #    source_type = "blank"
  #    destination_type = "local"
  #    volume_size = 1
  #    boot_index = 0
  #    delete_on_termination = false
  # }

}


# resource "openstack_blockstorage_volume_v2" "myvol" {
#    name = "myvol"
#    size = 1
#  } 


 resource "openstack_compute_volume_attach_v2" "attached" {

    instance_id = "${openstack_compute_instance_v2.instance_name.id}"
    volume_id = "bbc0daa2-897f-448e-95d0-e3fb16a388be"
   
 }

resource "openstack_compute_secgroup_v2" "securitygroup_1" {

    name = "security_group1"
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




resource "openstack_compute_floatingip_v2"  "floatingip_name" {
    pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "floatingip_name_associate" {
  floating_ip = "${openstack_compute_floatingip_v2.floatingip_name.address}"
  instance_id = "${openstack_compute_instance_v2.instance_name.id}"
  wait_until_associated = true

}




output "address" {
   value = "${openstack_compute_floatingip_v2.floatingip_name.address}"
}





