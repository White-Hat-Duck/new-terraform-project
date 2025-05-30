# General
variable "name" {
  description = "Name for the Panorama instance."
  type        = string
  default     = "pan-panorama"
}

variable "global_tags" {
  description = " "
  A map of tags to assign to the resources.
  If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  EOF
  default     = {}
  type        = map(any)
}

# Panorama
variable "product_code" {
  description = "Product code for Panorama BYOL license."
  type        = string
  default     = "eclz7j04vu9lf8ont8ta3n17o"
}

variable "panorama_version" {
  description = <<-EOF
  Panorama PAN-OS Software version. List published images with: 
  ```
  aws ec2 describe-images \\
  --filters "Name=product-code,Values=eclz7j04vu9lf8ont8ta3n17o" "Name=name,Values=Panorama-AWS*" \\
  --output json --query "Images[].Description" \| grep -o 'Panorama-AWS-.*' \| tr -d '",'
  ```
  EOF
  type        = string
  default     = "10.1.5"
}

variable "include_deprecated_ami" {
  description = <<-EOF
  In certain scenarios, customers may deploy a Panorama instance through the marketplace, 
  only to later discover that the ami has been deprecated, resulting in pipeline failures. 
  Setting the specified parameter to `true` will enable the continued use of deprecated AMIs, 
  mitigating this issue.
  EOF
  type        = bool
  default     = false
}

variable "panorama_ami_id" {
  description = <<-EOF
  Specific AMI ID to use for Panorama instance.
  If `null` (the default), `panorama_version` and `product_code` vars are used to determine a public image to use.
  EOF
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for Panorama. Default set to Palo Alto Networks recommended instance type."
  type        = string
  default     = "c5.4xlarge"
}

variable "ebs_encrypted" {
  description = "Whether to enable EBS encryption on root volume."
  default     = true
  type        = bool
}

variable "availability_zone" {
  description = "Availability zone in which Panorama will be deployed."
  type        = string
}

variable "ssh_key_name" {
  description = "AWS EC2 key pair name."
  type        = string
}

variable "create_public_ip" {
  description = "If true, create an Elastic IP address for Panorama."
  type        = bool
  default     = false
}

variable "private_ip_address" {
  description = "If provided, associates a private IP address to the Panorama instance."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch Panorama in."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate Panorama with."
  type        = list(any)
  default     = []
}

variable "ebs_volumes" {
  description = <<-EOF
  List of EBS volumes to create and attach to Panorama.
  Available options:
  - `name`              (Optional) Name tag for the EBS volume. If not provided defaults to the value of `var.name`.
  - `ebs_device_name`   (Required) The EBS device name to expose to the instance (for example, /dev/sdh or xvdh). 
  See [Device Naming on Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html#available-ec2-device-names) for more information.
  - `ebs_size`          (Optional) The size of the EBS volume in GiBs. Defaults to 2000 GiB.
  - `force_detach`      (Optional) Set to true if you want to force the volume to detach. Useful if previous attempts failed, but use this option only as a last resort, as this can result in data loss.
  - `skip_destroy`      (Optional) Set this to true if you do not wish to detach the volume from the instance to which it is attached at destroy time, and instead just remove the attachment from Terraform state. 
  This is useful when destroying an instance attached to third-party volumes.

  Note: Terraform must be running with credentials which have the `GenerateDataKeyWithoutPlaintext` permission on the specified KMS key 
  as required by the [EBS KMS CMK volume provisioning process](https://docs.aws.amazon.com/kms/latest/developerguide/services-ebs.html#ebs-cmk) to prevent a volume from being created and almost immediately deleted.
  If null, the default EBS encryption KMS key in the current region is used.

  Example:
  ```
  ebs_volumes = [
    {
      name              = "ebs-1"
      ebs_device_name   = "/dev/sdb"
      ebs_size          = "2000"
    },
    {
      name              = "ebs-2"
      ebs_device_name   = "/dev/sdb"
      ebs_size          = "2000"
    },
    {
      name              = "ebs-3"
      ebs_device_name   = "/dev/sdb"
      ebs_size          = "2000"
    },
  ]
  ```
  EOF
  type        = list(any)
  default     = []
}

variable "ebs_kms_key_alias" {
  description = <<-EOF
  The alias for the customer managed KMS key to use for volume encryption.
  If this is set to `null` the default master key that protects EBS volumes will be used
  EOF
  type        = string
  default     = "alias/aws/ebs"
}

variable "panorama_iam_role" {
  description = "IAM Role attached to Panorama instance contained curated IAM Policy."
  type        = string
}

variable "enable_imdsv2" {
  description = <<-EOF
  Whether to enable IMDSv2 on the EC2 instance.
  Support for this feature has been added in VM-Series Plugin [3.0.0](https://docs.paloaltonetworks.com/plugins/vm-series-and-panorama-plugins-release-notes/vm-series-plugin/vm-series-plugin-30/vm-series-plugin-300#id126d0957-95d7-4b29-9147-fff20027986e), which in turn requires PAN-OS version 10.2.0 at minimum.
  EOF
  default     = false
  type        = string
}

variable "enable_monitoring" {
  description = "(Optional) If true, the launched EC2 instance will have detailed monitoring enabled."
  default     = false
  type        = bool
}

variable "eip_domain" {
  description = "Indicates if this EIP is for use in VPC"
  default     = "vpc"
  type        = string
}
