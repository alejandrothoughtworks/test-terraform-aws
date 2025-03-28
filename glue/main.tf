provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "glue_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.glue_bucket.bucket
  key    = "scripts/glue_script.py"
  source = "${path.module}/scripts/glue_script.py"
  etag   = filemd5("${path.module}/scripts/glue_script.py")
}

resource "aws_iam_role" "glue_role" {
  name = "glue_basic_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_policy" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_glue_job" "example" {
  name     = "basic-glue-job"
  role_arn = aws_iam_role.glue_role.arn
  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.glue_bucket.bucket}/scripts/glue_script.py"
    python_version  = "3"
  }

  glue_version       = "3.0"
  number_of_workers  = 2
  worker_type        = "G.1X"
}
