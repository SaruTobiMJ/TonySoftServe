provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

terraform {
  required_version = ">= 0.15.5"
}

#Security Group
resource "aws_default_security_group" "TO-sg" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "TO-sg"
  }

  ingress {
    description      = "All data"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


#Key Pair
resource "aws_key_pair" "TO-ssh-key" {
  key_name   = "TO-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Instance 1
resource "aws_instance" "VM1-instance" {
  ami                         = "ami-052efd3df9dad4825"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.TO-ssh-key.key_name
  subnet_id                   = aws_subnet.mypublicsubnet-a.id
  associate_public_ip_address = true
  tags = {
    Name = "Instance 1"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install -y nginx",
      "sudo systemctl start nginx && sudo systemctl enable nginx",
      "sudo chmod -R 777 /var/www",
      "echo '<h1>Hello world 1</h1>' > /var/www/html/index.html",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}

#Instance 2
resource "aws_instance" "VM2-instance" {
  ami                         = "ami-052efd3df9dad4825"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.TO-ssh-key.key_name
  subnet_id                   = aws_subnet.mypublicsubnet-b.id
  associate_public_ip_address = true
  tags = {
    Name = "Instance 2"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install -y nginx",
      "sudo systemctl start nginx && sudo systemctl enable nginx",
      "sudo chmod -R 777 /var/www",
      "echo '<h1>Hello world 2</h1>' > /var/www/html/index.html",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}


#Load Balancer
resource "aws_lb" "TO-nlb" {
  name               = "TO-nlb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.mypublicsubnet-a.id, aws_subnet.mypublicsubnet-b.id]

  enable_deletion_protection = false

  tags = {
    Environment = "Development"
  }
}

resource "aws_lb_target_group" "TO-lb-tg" {
  name     = "TO-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.my-vpc.id
}

resource "aws_lb_target_group_attachment" "VM1-lb-tg-att-1" {
  target_group_arn = aws_lb_target_group.TO-lb-tg.arn
  target_id        = aws_instance.VM1-instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "VM2-lb-tg-att-2" {
  target_group_arn = aws_lb_target_group.TO-lb-tg.arn
  target_id        = aws_instance.VM2-instance.id
  port             = 80
}
#listener del load balancer
resource "aws_lb_listener" "TO-lb-listener" {
  load_balancer_arn = aws_lb.TO-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TO-lb-tg.arn
  }
}




