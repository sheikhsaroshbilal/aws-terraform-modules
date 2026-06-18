resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(local.tags, { Name = "${var.environment}-vpc" })
}
resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 4, count.index)
  availability_zone = var.azs[count.index]
  tags = merge(local.tags, { Name = "${var.environment}-private-${var.azs[count.index]}", "kubernetes.io/role/internal-elb" = "1" })
}
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index + length(var.azs))
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.tags, { Name = "${var.environment}-public-${var.azs[count.index]}", "kubernetes.io/role/elb" = "1" })
}
resource "aws_eip" "nat"         { count = length(var.azs); domain = "vpc" }
resource "aws_nat_gateway" "main" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}
locals { tags = { Environment = var.environment, ManagedBy = "terraform" } }