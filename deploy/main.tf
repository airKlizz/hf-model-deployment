# This data source retrieves a list of available AWS availability zones
data "aws_availability_zones" "available_zones" {
  state = "available"
}

# This resource creates a VPC with a CIDR block of 10.32.0.0/16
resource "aws_vpc" "default" {
  cidr_block = "10.32.0.0/16"
}

# This resource creates two public subnets in different availability zones
resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true
}

# This resource creates two private subnets in different availability zones
resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.default.id
}

# This resource creates an internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.default.id
}

# This resource creates a route to allow internet access for the VPC
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

# This resource creates two Elastic IPs for the internet gateway
resource "aws_eip" "gateway" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}

# This resource creates two NAT gateways, one for each Elastic IP
resource "aws_nat_gateway" "gateway" {
  count         = 2
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
}

# This resource creates two route tables for the private subnets
resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
}

# This creates two route table associations, one for each subnet
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_ecs_cluster" "main" {
  name = "hf-model-deployment-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "ecs_log_group"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "ecs_task_execution_policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_security_group" "lb" {
  name        = "alb-security-group"
  vpc_id      = aws_vpc.default.id

  # Ingress rule allowing incoming traffic on all ports
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rule allowing all outgoing traffic
  egress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
