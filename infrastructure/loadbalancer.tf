# # target group
# resource "aws_lb_target_group" "alb-tg" {
#   name     = "my-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.iti-vpc.id
#   target_type = "instance"

#   health_check {
#     path = "/"
#     port = 80
#   }
# }

# # alb
# resource "aws_lb" "alb" {
#   name            = "my-loadbalancer"
#   internal           = false  # internet facing 
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.allow_tls.id] 
#   subnets         = [aws_subnet.public-subnet1.id,aws_subnet.public-subnet2.id]

# }

# # alb listener
# resource "aws_lb_listener" "alb-listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb-tg.arn
#   }
# }

# # attach ec2 to tg
# resource "aws_lb_target_group_attachment" "tg-attach" {
#   target_group_arn = aws_lb_target_group.alb-tg.arn
#   target_id        = aws_instance.ec2_private.id

# }
# resource "aws_lb_target_group_attachment" "tg-attach2" {
#   target_group_arn = aws_lb_target_group.alb-tg.arn
#   target_id        = aws_instance.ec2_private2.id

# }

