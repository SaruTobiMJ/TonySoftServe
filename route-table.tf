# Creating RT for Public Subnet
resource "aws_route_table" "TO-rt-pub" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}
#Associating the Public RT with the Public Subnets
resource "aws_route_table_association" "TO-rt-pub-a" {
  subnet_id      = aws_subnet.mypublicsubnet-a.id
  route_table_id = aws_route_table.TO-rt-pub.id
}
resource "aws_route_table_association" "TO-rt-pub-b" {
  subnet_id      = aws_subnet.mypublicsubnet-b.id
  route_table_id = aws_route_table.TO-rt-pub.id
}
