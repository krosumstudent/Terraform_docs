variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "AD" {}
#--- provider
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

resource "oci_objectstorage_bucket" "TF-bucket" {

        compartment_id = "${var.compartment_ocid}"
        namespace =  "ocuocictrng31"
        name = "TF-example-bucket"
}

resource "oci_objectstorage_preauthrequest" "test_preauthenticated_request" {
#Required
access_type = "AnyObjectWrite"
bucket = "TF-example-bucket"
name = "TF-example-preauth"
namespace = "ocuocictrng31"
time_expires = "2023-06-01T00:09:51.000+02:00"
}

