resource "aws_subnet" "mypublicsubnet-a" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.pubsubcidr-a
}
resource "aws_subnet" "mypublicsubnet-b" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.pubsubcidr-b
}
