module "vpc" {
  source   = "./modules/vpc"
  app_name = "challenge-fiap"
  env      = "dev"
}

module "database" {
  source            = "./modules/database"
  env               = "dev"
  app_name          = "challenge-fiap"
  db_instance_class = "db.t3.micro"
  db_identifier     = "challenge"
  db_name           = "challenge"
  db_username       = "challenge"
  db_password       = "challenge"
  subnet_ids        = [module.vpc.subnet_publica_id_a, module.vpc.subnet_publica_id_b]

  vpc_security_group_ids = [module.security_group_postgres.id]
}

module "security_group_postgres" {
  source = "./modules/security-group"

  name        = "challenge-fiap-postgres"
  description = "Permite a conexao publica com postgress "
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      description = "TCP postgress Allowed"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress_rules = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}