variable "s3_bucket_name" {
  description = "S3 bucket for Glue scripts"
  default     = "my-glue-script-bucket-demo-1234563213213213213"
}

variable "glue_script_s3_path" {
  description = "S3 path to the Glue script"
  type        = string
}