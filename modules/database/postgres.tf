resource "aws_db_subnet_group" "subnet_group" {
  name       = var.app_name
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "db_postgres" {
  multi_az                     = true
  allocated_storage            = var.db_allocated_storage
  max_allocated_storage        = var.db_max_allocated_storage
  skip_final_snapshot          = true
  publicly_accessible          = true
  engine                       = "postgres"
  engine_version               = var.db_engine_version
  port                         = var.db_port
  db_subnet_group_name         = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids       = var.vpc_security_group_ids
  instance_class               = var.db_instance_class
  db_name                      = replace(var.db_name, "-", "")
  username                     = replace(var.db_username, "-", "")
  password                     = var.db_password
  identifier                   = replace(var.db_identifier, "-", "")
  backup_retention_period      = 7
  auto_minor_version_upgrade   = false
  deletion_protection          = false
  performance_insights_enabled = true

  lifecycle {
    ignore_changes = all
  }

  tags = {
    Name = var.app_name
  }
}