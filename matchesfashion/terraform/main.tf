#======= Definig backend storage S3 ==========

terraform {
  backend "s3" {
    bucket = "matchesfashion-test"
    key    = ""
    region = "eu-west-2"
  }
}

#======== Defining terraform workspace ========

locals {
  map_workspace_profile = {
    dev    = "dev"
    qa     = "qa"
    test   = "test"
    uat    = "uat"
    prod   = "prod"
  }

  map_workspace_region = {
    dev    = "eu-west-2"
    qa     = "eu-west-2"
    test   = "eu-west-2"
    uat    = "eu-west-2"
    prod   = "eu-west-2"
  }
}

locals {
  profile = "${local.map_workspace_profile [terraform.workspace]}"
  region  = "${local.map_workspace_region  [terraform.workspace]}"
}


#======= IAM User Variable declaration =========================

variable "iam_user" {
  type = "list"
  default = ["nevsa","cordelia","kriste","darleen","wunnie","vonnie","emelita","maurita","devinne","breena"]
  description = "IAM Users"
}

#======= IAM User Definition ===================================

resource "aws_iam_user" "matchesfashion" {
  name = "${element(var.iam_user,count.index)}"
  count = "${length(var.iam_user)}"
  lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_access_key" "matchesfashion" {
  name = "${aws_iam_user.matchesfashion.name}"
}

#======= Defining IAM Groups ===================================

resource "aws_iam_group" "matchesfashion" {
 name = "EC2access"
}


#======= Defining IAM User and Group membership ================

resource "aws_iam_group_membership" "iam_matchesfashion" {
 name = "IAM-user-group-membership-EC2access"
 users = [
   "${aws_iam_user.matchesfashion.*.name}"
]
 group = "${aws_iam_group.matchesfashion.name}"
}


#======= Defining IAM Policies and attachment to IAM groups ===

resource "aws_iam_policy_attachment" "iam_Policy" {
 name = "EC2-Full-Access"
 count = "${length(var.iam_user)}"
 groups = ["${aws_iam_group.matchesfashion.name}"]
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
 lifecycle {
    create_before_destroy = true
 }
}
