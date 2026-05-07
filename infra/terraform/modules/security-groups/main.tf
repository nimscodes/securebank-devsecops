resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Controls inbound traffic to the SecureBank ALB."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP traffic to the ALB."
  cidr_ipv4         = var.alb_ingress_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  count = var.enable_https_ingress ? 1 : 0

  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic to the ALB."
  cidr_ipv4         = var.alb_ingress_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow ALB egress to application targets."
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-ecs-sg"
  description = "Controls inbound traffic to SecureBank ECS services."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_web_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Allow ALB traffic to the web container."
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.web_container_port
  ip_protocol                  = "tcp"
  to_port                      = var.web_container_port
}

resource "aws_vpc_security_group_ingress_rule" "ecs_api_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Allow ALB traffic to the API container."
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.api_container_port
  ip_protocol                  = "tcp"
  to_port                      = var.api_container_port
}

resource "aws_vpc_security_group_egress_rule" "ecs_all" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow ECS tasks to reach required AWS services and database endpoints."
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Controls PostgreSQL access from SecureBank ECS tasks."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
  security_group_id            = aws_security_group.rds.id
  description                  = "Allow PostgreSQL traffic from ECS tasks."
  referenced_security_group_id = aws_security_group.ecs.id
  from_port                    = var.database_port
  ip_protocol                  = "tcp"
  to_port                      = var.database_port
}

resource "aws_vpc_security_group_egress_rule" "rds_all" {
  security_group_id = aws_security_group.rds.id
  description       = "Allow database egress for managed service operations."
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
