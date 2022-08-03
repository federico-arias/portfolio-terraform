resource "aws_instance" "bastion" {
  ami                         = "ami-002068ed284fb165b"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  subnet_id                   = module.vpc.public_subnets[0]

  key_name = "${var.project}-db-access-key"

  /*
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu" # ec2-user
      private_key = file("/home/federico/.ssh/aws_bastion")
      timeout     = "1m"
   }
*/
}

resource "aws_security_group" "bastion-sg" {
  name   = "${var.project}-bastion-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "${var.project}-db-access-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCx8oRFFQQjz4SEdaO9115uH4PJQ91raU6ufYj4U9WNAavVBWTwEp4a0sd6pGHkFOMgIBuCG4QYJOOH0dPtY40JOPn0MCZFijYUxbAzJLCebAWFutDGdJ0HQGXgs7zkEmvPO+NcdzeqaEpd+IGstLBmx5w1iH2xEHzi8z9bc9adnfZqrgMhZ2ozuoy2eEIb7Jf43JfCjiJoaA7/6BGceaFZioKyOiLQvoGGQAlGlDUkXcGKIWnfC5GhqNCtGtsbkeOMGhjFBbeqASosa3CsPIFAOO3xvCsTRHNy2O3/+0GMKSB6ELWPEUlod3yGIOKzJbHx5RcCduzbRCzG2h0PJdWIJwTu1CarmD8aTx2bUoB3nMblAf60mzlpYFXCp3C0aFG5O3Lcn1yUbc7dP2bcRCc9zmJAHZUHqKn9SiTQ42CGb9hVCYhypj2DAhOGcOJI8dVEyJ/yWlbbu59jOAynBljbO0trP4HI3aH5xY0or5Pa0YNrc5NXIf04GNYkIVq6WSD7/oiUVTwhcaQmfu6359jMorpe4pGi3LRZbm+R87bUWF17Kg2dYpGc6SikO1hi/DIUN1Aa3Vw+GbhzNM3XhbAoECGcHxluZ3PQw7HeKyOZyzb7xvnUBfqtPyO7HK7RDoS8BnDRsruK6UgzfxCbFdjDJNY8xST8zfEty84bM+aEYQ== federicoariasr@gmail.com"
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
