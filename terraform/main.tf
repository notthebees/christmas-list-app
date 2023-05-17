provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "webserver" {
  name = "webserver-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ALLOWED_IP_ADDRESS]
  }
}

resource "aws_instance" "webserver" {
  ami                    = "ami-09744628bed84e434"
  instance_type          = "t2.micro"
  key_name               = "pm_web_server"
  vpc_security_group_ids = [aws_security_group.webserver.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.PRIVATE_KEY_PATH)
    host = self.public_ip
  }

  tags = {
    Name = "webserver"
  }
}
