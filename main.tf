provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_app" {
  ami           = "ami-0b437d2581359bcf3"
  instance_type = "t2.micro"

  tags = {
    Name = "WebAppInstance"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("assignment1-dev")  # Use relative path to your private key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",  # For Amazon Linux 2
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]
  }
}

resource "aws_ecr_repository" "web_app" {
  name = "my-web-app"
}

resource "aws_ecr_repository" "mysql" {
  name = "my-mysql"
}
