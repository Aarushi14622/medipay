# MediPay's own rules for Terraform, written as code (Policy as Code).
# Checkov covers general best practice; these are OUR organisation's rules.
# Run: conftest test --parser hcl2 --policy policies/conftest terraform/**/*.tf
package main

import rego.v1

allowed_regions := {"eu-west-2"} # London only: UK data residency for health data

valid_classifications := {"public", "internal", "confidential"}

# Rule 1: AWS resources may only be created in the UK.
deny contains msg if {
	some p in input.provider.aws
	not p.region in allowed_regions
	msg := sprintf("AWS provider region %v is not allowed; use eu-west-2 (UK data residency)", [p.region])
}

# Rule 2: every bucket says how sensitive its data is.
deny contains msg if {
	some name, blocks in input.resource.aws_s3_bucket
	some b in blocks
	not b.tags.data_classification
	msg := sprintf("aws_s3_bucket.%v has no data_classification tag", [name])
}

deny contains msg if {
	some name, blocks in input.resource.aws_s3_bucket
	some b in blocks
	c := b.tags.data_classification
	not c in valid_classifications
	msg := sprintf("aws_s3_bucket.%v has data_classification %v; use public, internal or confidential", [name, c])
}

# Rule 3: public access blocks must block everything.
public_access_settings := ["block_public_acls", "block_public_policy", "ignore_public_acls", "restrict_public_buckets"]

deny contains msg if {
	some name, blocks in input.resource.aws_s3_bucket_public_access_block
	some b in blocks
	some setting in public_access_settings
	b[setting] != true
	msg := sprintf("aws_s3_bucket_public_access_block.%v must set %v = true", [name, setting])
}

# Rule 4: no public ACLs, ever.
deny contains msg if {
	some name, blocks in input.resource.aws_s3_bucket_acl
	some b in blocks
	startswith(b.acl, "public")
	msg := sprintf("aws_s3_bucket_acl.%v uses a public ACL (%v)", [name, b.acl])
}
