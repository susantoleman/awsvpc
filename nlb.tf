resource "aws_lb" "int-nlb" {
  load_balancer_type = "network"
  internal           = true
  subnet_mapping {
    subnet_id = aws_subnet.web_vpc-priv1.id
    private_ipv4_address = "10.1.1.99"
  } 
  subnet_mapping {
    subnet_id = aws_subnet.web_vpc-priv2.id
    private_ipv4_address = "10.1.10.99"
  }
} 

resource "aws_lb_listener" "listener" {
  load_balancer_arn   = aws_lb.int-nlb.arn
  for_each            = var.forwarding_config 
     port      = each.key
     protocol  = each.value
     default_action {
       type              = "forward"
       target_group_arn  = aws_lb_target_group.front_end[each.key].arn
     }
}

resource "aws_lb_target_group" "front_end" {
   for_each     = var.forwarding_config
   port 	      = each.key
   protocol	    = each.value
   vpc_id       = aws_vpc.web_vpc.id
   target_type  = "ip"
   
  health_check {
	  interval  = 10
	  protocol  = each.value
	  port      = var.healthport
  }
}

resource "aws_lb_target_group_attachment" "target1" {
  for_each            = var.forwarding_config
  depends_on          = [aws_lb_target_group.front_end]
  target_group_arn    = aws_lb_target_group.front_end[each.key].arn
  target_id           = var.target1_id
  port                = each.key
}

resource "aws_lb_target_group_attachment" "target2" {
  for_each            = var.forwarding_config
  depends_on          = [aws_lb_target_group.front_end]
  target_group_arn    = aws_lb_target_group.front_end[each.key].arn
  target_id           = var.target2_id
  port                = each.key
}
