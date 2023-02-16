resource "aws_vpc" "iti-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

// subnets ["10.0.0.0/24","10.0.2.0/24"]
resource "aws_subnet" "public-subnet1" {
  cidr_block       = "10.0.0.0/24"
  vpc_id = aws_vpc.iti-vpc.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  cidr_block       = "10.0.2.0/24"
  vpc_id = aws_vpc.iti-vpc.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-subnet2"
  }
}

// private subnets  [ "10.0.1.0/24", "10.0.3.0/24"]
resource "aws_subnet" "private-subnet1" {
  cidr_block       = "10.0.1.0/24"
  vpc_id = aws_vpc.iti-vpc.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet1"
  }
}

resource "aws_subnet" "private-subnet2" {
  cidr_block       = "10.0.3.0/24"
  vpc_id = aws_vpc.iti-vpc.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet2"
  }
}

// igw 
resource "aws_internet_gateway" "gw" {
  vpc_id =  aws_vpc.iti-vpc.id

  tags = {
    Name = "my-internet-gatway"
  }
}

//nat 
resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet1.id
  tags = {
    Name = "my-nat"
  }
  depends_on = [aws_internet_gateway.gw]
}

// public routing table
resource "aws_route_table" "publicRoute" {

  vpc_id = aws_vpc.iti-vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my-public-route-table" 
  }
}

# private routing table
resource "aws_route_table" "privateRoute" {
  vpc_id =  aws_vpc.iti-vpc.id

  route {
    cidr_block =  "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "my-private-route-table"
  }
}

resource "aws_route_table_association" "public-subnet-route" {  
  subnet_id = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.publicRoute.id
}

resource "aws_route_table_association" "public-subnet-route-2" {  
  subnet_id = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.publicRoute.id
}

resource "aws_route_table_association" "private-subnet-route" {  
  subnet_id = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.privateRoute.id
}

resource "aws_route_table_association" "private-subnet-route-2" {  
  subnet_id = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.privateRoute.id
}


# security group
resource "aws_security_group" "allow_tls" {
  name        = "my-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.iti-vpc.id

  ingress {
    from_port        = 80 #http
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22 #ssh
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 65535
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 
}