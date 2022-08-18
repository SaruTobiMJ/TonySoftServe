# Create Internet Gateway resource and attach it to the VPC

resource "aws_internet_gateway" "IGW" {

  vpc_id = aws_vpc.my-vpc.id

}

# Create EIP for the IGW

resource "aws_eip" "myEIP" {
  vpc = true
}
