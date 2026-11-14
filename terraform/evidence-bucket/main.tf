# Audit evidence store: where SBOMs, scan reports and CI evidence are kept.
# The point is that evidence can't be read publicly, quietly changed or deleted.

resource "aws_kms_key" "evidence" {
  description             = "Encrypts MediPay audit evidence"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.kms.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms" {
  # In a KMS *key policy*, resources = ["*"] means "this key only". Granting the
  # account root is AWS's default key policy; IAM policies then decide who uses it.
  #checkov:skip=CKV_AWS_111:Key policy; "*" refers to this key only
  #checkov:skip=CKV_AWS_356:Key policy; "*" refers to this key only
  #checkov:skip=CKV_AWS_109:Key policy; AWS default account-root admin statement
  statement {
    sid       = "AccountAdmin"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_s3_bucket" "evidence" {
  #checkov:skip=CKV_AWS_144:Cross-region replication out of the UK would break data residency; accepted for a lab (see decision log)
  #checkov:skip=CKV2_AWS_62:Event notifications not needed for a lab evidence store
  bucket = var.bucket_name

  tags = {
    data_classification = "confidential"
    purpose             = "audit-evidence"
  }
}

resource "aws_s3_bucket_public_access_block" "evidence" {
  bucket                  = aws_s3_bucket.evidence.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "evidence" {
  bucket = aws_s3_bucket.evidence.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.evidence.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id
  rule {
    id     = "keep-evidence-then-expire"
    status = "Enabled"
    filter {}
    noncurrent_version_expiration {
      noncurrent_days = 365
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_logging" "evidence" {
  bucket        = aws_s3_bucket.evidence.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "evidence/"
}

# Refuse any request that isn't over HTTPS.
data "aws_iam_policy_document" "tls_only" {
  statement {
    sid       = "DenyInsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.evidence.arn, "${aws_s3_bucket.evidence.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "evidence" {
  bucket = aws_s3_bucket.evidence.id
  policy = data.aws_iam_policy_document.tls_only.json
}

# Bucket that receives the access logs ("who touched the evidence?").
resource "aws_s3_bucket" "access_logs" {
  #checkov:skip=CKV_AWS_144:Cross-region replication out of the UK would break data residency
  #checkov:skip=CKV2_AWS_62:Event notifications not needed for access logs
  #checkov:skip=CKV_AWS_18:This IS the access-log bucket; logging it to itself would loop
  #checkov:skip=CKV_AWS_145:S3 server access logs only support SSE-S3 (AES256) on the target bucket
  bucket = "${var.bucket_name}-access-logs"

  tags = {
    data_classification = "internal"
    purpose             = "access-logs"
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket                  = aws_s3_bucket.access_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  rule {
    id     = "expire-logs"
    status = "Enabled"
    filter {}
    expiration {
      days = 400
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
