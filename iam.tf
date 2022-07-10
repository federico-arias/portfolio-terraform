resource "aws_iam_user" "ecr_pusher" {
  name = "${var.project}-ecr-pusher"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_user_policy_attachment" "ecr_pusher" {
  user       = aws_iam_user.ecr_pusher.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_access_key" "ecr_pusher" {
  user = aws_iam_user.ecr_pusher.name
  #  pgp_key = "keybase:some_person_that_exists"
}
