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
  default = "172.27.83.155"
}

variable "volume_id" {
  default = "db734b93-7ed5-4a64-b752-72e7386f4165"
}

variable "private_key_path" {
  default = "~/.ssh/clara.key"
}

variable "http_port" {
  default = 80
}






resource "openstack_compute_instance_v2" "instance_name" {
  name = "eta-cellgen-ca6-test"
  image_name = "bionic-WTSI-docker_b5612"
  flavor_name = "m1.xlarge"
  key_pair = "${var.openstack_key_pair}"
  security_groups = ["${openstack_compute_secgroup_v2.securitygroup_1.name}"]
  network {
      name = "${var.openstack_tenant_network}"

  }


}


resource "null_resource" "null_provisioner" {

    triggers = {
      instance_id  = "${openstack_compute_instance_v2.instance_name.id}"
    }

    connection {
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    host = "${var.floating_ip}"
  }


  provisioner "remote-exec" {
    inline = [
      "echo"
    ]
    on_failure = "continue"

  }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command = "ansible-playbook -i inventory playbook.yml "
    on_failure = "continue"    
    #mTips from https://jite.eu/2018/7/16/terraform-and-ansible/ : use -i ${self.ipv4_address}. I would recommend that you in either the ansible script or a local-exec provisioner clause remove and then add the server host keys, that way you will not have to manually tell the script that you accept the host keys, and you can make sure that the ansible tasks don’t fail because the host is wrong 
  }

}


resource "openstack_compute_volume_attach_v2" "eta-cellgen-ca6-volume-test" {
    instance_id = "${openstack_compute_instance_v2.instance_name.id}"
    volume_id = "${var.volume_id}"   
 }

resource "openstack_compute_secgroup_v2" "securitygroup_1" {
    name = "security_group_ca6_test"
    description = "allows ssh and http/https access to ports 80 and 22"

    rule {
        from_port = "${var.http_port}"
        to_port = "${var.http_port}"
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

resource "openstack_compute_floatingip_associate_v2" "floatingip_name_associate" {
  floating_ip = "${var.floating_ip}"
  instance_id = "${openstack_compute_instance_v2.instance_name.id}"
  wait_until_associated = false
}


output "address" {
   value = "${var.floating_ip}:${var.http_port}"

}