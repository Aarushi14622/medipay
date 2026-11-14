# CloudTrail = the account's audit log: who did what, when, from where.
# Like the web server access logs from DAST work, but for the whole AWS account.

resource "aws_kms_key" "cloudtrail" {
  description             = "Encrypts MediPay CloudTrail logs"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.cloudtrail_kms.json
}

data "aws_iam_policy_document" "cloudtrail_kms" {
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
  statement {
    sid       = "CloudTrailEncrypt"
    actions   = ["kms:GenerateDataKey*", "kms:DescribeKey"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }
  }
}

resource "aws_s3_bucket" "trail" {
  #checkov:skip=CKV_AWS_144:Cross-region replication out of the UK would break data residency
  #checkov:skip=CKV2_AWS_62:Event notifications not needed for the trail bucket
  #checkov:skip=CKV_AWS_18:Access logging for the trail bucket is a known gap for the lab (would need a third bucket)
  bucket = "medipay-cloudtrail-${data.aws_caller_identity.current.account_id}"

  tags = {
    data_classification = "confidential"
    purpose             = "cloudtrail"
  }
}

resource "aws_s3_bucket_public_access_block" "trail" {
  bucket                  = aws_s3_bucket.trail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "trail" {
  bucket = aws_s3_bucket.trail.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "trail" {
  bucket = aws_s3_bucket.trail.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.cloudtrail.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "trail" {
  bucket = aws_s3_bucket.trail.id
  rule {
    id     = "retain-then-expire"
    status = "Enabled"
    filter {}
    expiration {
      days = 400
    }
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

data "aws_iam_policy_document" "trail_bucket" {
  statement {
    sid       = "CloudTrailAclCheck"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.trail.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid       = "CloudTrailWrite"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.trail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid       = "DenyInsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.trail.arn, "${aws_s3_bucket.trail.arn}/*"]
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

resource "aws_s3_bucket_policy" "trail" {
  bucket = aws_s3_bucket.trail.id
  policy = data.aws_iam_policy_document.trail_bucket.json
}

resource "aws_cloudtrail" "main" {
  #checkov:skip=CKV_AWS_252:SNS notifications for new log files not needed in the lab
  #checkov:skip=CKV2_AWS_10:CloudWatch Logs integration is a known gap (cost); alerting planned in continuous monitoring doc
  name                          = "medipay-trail"
  s3_bucket_name                = aws_s3_bucket.trail.id
  is_multi_region_trail         = true # catch activity in regions we don't use, too
  include_global_service_events = true # IAM changes
  enable_log_file_validation    = true # detect tampered or deleted log files
  kms_key_id                    = aws_kms_key.cloudtrail.arn

  depends_on = [aws_s3_bucket_policy.trail]
}
