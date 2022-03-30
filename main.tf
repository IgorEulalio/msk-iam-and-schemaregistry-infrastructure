resource "aws_security_group" "msk_sg" {
  name        = "allow_tls_msk_broker"
  description = "Allow TLS inbound traffic for port 9092"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS 9198 from VPC."
    from_port        = 9198
    to_port          = 9198
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
  }

  ingress {
    description      = "TLS 2181 from VPC."
    from_port        = 2181
    to_port          = 2181
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls_msk_broker"
  }
}

resource "aws_kms_key" "msk_key" {
  description = "KMS key to encrypt data at rest in MSK brokers."
}

resource "aws_cloudwatch_log_group" "cwloggroup" {
  name = "msk_broker_logs"
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "msk-microservices-cluster"
  kafka_version          = "2.6.2"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = var.msk_broker_instance_type
    ebs_volume_size = var.ebs_volume_size
    client_subnets = [
      var.subnet_az1_id,
      var.subnet_az2_id,
      var.subnet_az3_id,
    ]
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_key.arn
  }

  client_authentication {
    sasl {
      iam = true
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.cwloggroup.name
      }
    }
  }

  tags = {
    Name = "msk-microservices-cluster"
  }
}