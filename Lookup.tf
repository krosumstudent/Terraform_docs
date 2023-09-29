[root@terraformserver lookup_example]# cat main.tf
variable "fsinfo" {
        type = map
        default = {
                fstype = "xfs"
                fpart  = "/dev/xvdb1"
                fsize  = "150GB"
        }
}
variable "name"{
        type = string
}
output "display"{
        value="${lookup(var.fsinfo,"${var.name}")}"
}
[root@terraformserver lookup_example]#

[root@terraformserver lookup_example]# terraform apply
var.name
  Enter a value: fstype {Enter}

Outputs:

display = "xfs"



