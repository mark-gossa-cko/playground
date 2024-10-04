data "aws_caller_identity" "current" {}

resource "aws_kms_key" "ckoma" {
  description             = "An example symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
}

resource "aws_kms_key_policy" "ckoma" {
  key_id = aws_kms_key.ckoma.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = "*",
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

# Foreach app in apps
  resource "aws_secretsmanager_secret" "ckoma-app1" {
    name = "ckoma-test-app1"
  }

  resource "null_resource" "ckoma-app1" {
    triggers = {
        trigger = uuid() # change to trigger if older than x days
    }

    provisioner "local-exec" {
    command = ". ${path.root}\\create-secret-value.ps1 -KeyId ${aws_kms_key.ckoma.id} -Secret ${aws_secretsmanager_secret.ckoma-app1.arn}"
    interpreter = [ "pwsh", "-Command" ]
    }
  }
# end foreach