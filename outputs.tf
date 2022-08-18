output "TO-VM1-pub-ip" {
  value = aws_instance.VM1-instance.public_ip
}

output "TO-VM2-pub-ip" {
  value = aws_instance.VM2-instance.public_ip
}

output "TO-dns-nlb" {
  value = aws_lb.TO-nlb.dns_name
}

