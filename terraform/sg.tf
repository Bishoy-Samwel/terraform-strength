resource "aws_security_group" "sg" {
    name        = "${var.env}-inbound"
    description = "Security group for ${var.env} environment"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port   = 443
        to_port     = 445
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }