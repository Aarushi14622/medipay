# Unit tests: each rule must catch a bad example and allow a good one.
# Run: conftest verify --policy policies/conftest
package main

import rego.v1

test_london_region_allowed if {
	count(deny) == 0 with input as {"provider": {"aws": [{"region": "eu-west-2"}]}}
}

test_us_region_denied if {
	some msg in deny with input as {"provider": {"aws": [{"region": "us-east-1"}]}}
	contains(msg, "not allowed")
}

test_bucket_without_classification_denied if {
	some msg in deny with input as {"resource": {"aws_s3_bucket": {"x": [{"bucket": "x"}]}}}
	contains(msg, "no data_classification")
}

test_bucket_with_made_up_classification_denied if {
	some msg in deny with input as {"resource": {"aws_s3_bucket": {"x": [{"tags": {"data_classification": "secretish"}}]}}}
	contains(msg, "use public, internal or confidential")
}

test_classified_bucket_allowed if {
	count(deny) == 0 with input as {"resource": {"aws_s3_bucket": {"x": [{"tags": {"data_classification": "confidential"}}]}}}
}

test_partial_public_access_block_denied if {
	some msg in deny with input as {"resource": {"aws_s3_bucket_public_access_block": {"x": [{
		"block_public_acls": true,
		"block_public_policy": false,
		"ignore_public_acls": true,
		"restrict_public_buckets": true,
	}]}}}
	contains(msg, "block_public_policy")
}

test_public_acl_denied if {
	some msg in deny with input as {"resource": {"aws_s3_bucket_acl": {"x": [{"acl": "public-read"}]}}}
	contains(msg, "public ACL")
}
