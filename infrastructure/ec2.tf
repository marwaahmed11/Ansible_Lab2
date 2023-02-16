resource "aws_instance" "ec2_public" {
    tags = {
        Name = "jump-host"
    }
    key_name = "ansible-key"
    ami = "ami-0557a15b87f6559cf" # ubuntu 
    subnet_id = aws_subnet.public-subnet1.id
    instance_type = "t2.micro"
    associate_public_ip_address = "true" #enable ip 
    security_groups = [aws_security_group.allow_tls.id]
  

}

resource "aws_instance" "ec2_private" {
    tags = {
        Name = "private-ec2-1"
    }
    key_name = "ansible-key"
    ami = "ami-0557a15b87f6559cf"
    subnet_id = aws_subnet.private-subnet1.id
    instance_type = "t2.medium"
    associate_public_ip_address = "false" #enable ip 
    security_groups = [aws_security_group.allow_tls.id]
  
  
}

resource "aws_instance" "ec2_private2" {
    tags = {
        Name = "private-ec2-2"
    }
    ami = "ami-0dfcb1ef8550277af" # aws linx
    key_name = "ansible-key"
    subnet_id = aws_subnet.private-subnet2.id
    instance_type = "t2.medium"
    associate_public_ip_address = "false" #enable ip 
    security_groups = [aws_security_group.allow_tls.id]
  

}