# we create two roles a "task role" and a "execution role", which are used in
# the ECS task definition. They allow the communication with ECR and CloudWatch.

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole-${var.project}-${var.environment}"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-${var.project}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



# See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_policy" "ecr" {
  name        = "${var.project}-${var.environment}-task-policy-ecr"
  description = "Policy that allows access to ECR. Additionaly, it allows acces to Systems Manager"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents",
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "allow-ecs-to-ecr" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_role_policy_attachment" "allow-ecs-execution-to-ecr" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecr.arn
}
