# Instance role's assume policy document
data "aws_iam_policy_document" "d_pd_instance_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}