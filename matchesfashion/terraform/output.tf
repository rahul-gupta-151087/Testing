output "aws_iam_access_key_id" {
  description = "The access key ID"
  value       = "${aws_iam_access_key.matchesfashion.id}"
}

output "aws_iam_access_key_secret" {
  description = "The access key secret"
  value       = "${aws_iam_access_key.matchesfashion.secret}"
}

