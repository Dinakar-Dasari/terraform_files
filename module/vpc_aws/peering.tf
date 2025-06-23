resource "aws_vpc_peering_connection" "main" {
  count       = var.is_peering_required ? 1 : 0
  peer_vpc_id = data.aws_vpc.default.id
  vpc_id      = aws_vpc.main.id
  auto_accept = true
    accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = merge(var.tags,
    {
      Name = "${var.tag}-${var.environment["Name"]}-vpc"
    }
  )
}

resource "aws_route" "public_peering" {
  count       = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id   #since we are creating using count at line2 use count.index
}
##you can add for all route tables or one anything is fine

# add peering routes for default vpc

resource "aws_route" "default_peering" {
  count       = var.is_peering_required ? 1 : 0
  route_table_id         = data.aws_route_table.main.id
  destination_cidr_block = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id   #since we are creating using count at line2 use count.index
}