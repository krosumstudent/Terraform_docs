export TF_VAR_tenancy_ocid=""
export TF_VAR_user_ocid=""
export TF_VAR_fingerprint=""
export TF_VAR_private_key_path=""
export TF_VAR_compartment_ocid=""
### Region
export TF_VAR_region="eu-frankfurt-1"
export TF_VAR_AD="1"
export TF_VAR_LOG=DEBUG
export TF_VAR_LOG_PATH="terraformlogs.log"
export TF_VAR_subnet_id=""
[root@terraformserver ex4]# cat main.tf
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "AD" {}
variable "subnet_id" {}
#--- provider
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}


variable "ssh-key-file" {
  default = "ssh-key-file.key"
}



data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_instance" "ubuntu_instance" {
  # Required
  # https://docs.oracle.com/en-us/iaas/images/image/81eb1ed9-cea8-4c6f-832d-e41f7741b812/
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 16
    ocpus         = 1
  }


  source_details {
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7sfphoisa77bnblpnel74get6vzoofo4xix535nwdmfsnbscm4xa"
    source_type = "image"
  }


  # Optional
  count          = 1
  display_name   = format("%s-%s", "websrv", count.index)
  hostname_label = format("%s-%s", "websrv", count.index)


  #display_name = "oraclelinux-dj-14"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.subnet_id
  }
  metadata = {
    ssh_authorized_keys = file("${var.ssh-key-file}")
  }
  preserve_boot_volume = false

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      port        = 22
      user        = "opc"
      agent       = "false"
      host        = self.public_ip
      private_key = file("sshprivatekey.key")
    }
    inline = [
      "echo test connection successful",
      "cat /etc/hosts"

    ]

  }
}


output "public-ip-for-compute-instance" {
  value = oci_core_instance.ubuntu_instance[*].public_ip
}