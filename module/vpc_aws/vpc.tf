resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_subnet" "public" {
  count                   = length(var.cidr_public)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_public[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-public-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.cidr_private)
  cidr_block        = var.cidr_private[count.index]
  availability_zone = local.az_names[count.index]
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-private-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "database" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.cidr_database)
  cidr_block        = var.cidr_database[count.index]
  availability_zone = local.az_names[count.index]
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-database-${local.az_names[count.index]}"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  # we need to assaign a publi subnet , as we have 2 public subnets we will assign primary one
  subnet_id = aws_subnet.public[0].id
  tags = merge(var.tags,
    {
      Name = "${var.tags["Name"]}-NAT"
    }
  )
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags,
    {
      Name = "${var.tags["Name"]}-${var.environment["Name"]}-public"
    }
  )
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags,
    {
      Name = "${var.tags["Name"]}-${var.environment["Name"]}-private"
    }
  )
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags,
    {
      Name = "${var.tags["Name"]}-${var.environment["Name"]}-database"
    }
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NAT.id
}

resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NAT.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.cidr_public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.cidr_private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count          = length(var.cidr_database)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}


