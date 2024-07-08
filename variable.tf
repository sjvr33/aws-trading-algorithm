variable "vpc-cidr" {
  default     = "00.000.0.000/00"
  description = "vpc cidr block"
  type        = string
}

variable "private-subnet-1-cidr" {
  default     = "00.000.0.000/00"
  description = "private subnet 1 cidr block"
  type        = string
}

variable "private-subnet-2-cidr" {
  default     = "00.000.0.000/00"
  description = "private subnet 2 cidr block"
  type        = string
}

variable "public-subnet-cidr" {
  default     = "00.000.0.000/00"
  description = "private subnet 2 cidr block"
  type        = string
}

variable "database-snapshot-identifier" {
  default     = "arn:aws:rds:us-east-1:xxxxx:snapshot:test-mysql-db"
  description = "the database snapshot arn"
  type        = string
}

variable "database-instance-class" {
  default     = "db.t2.micro"
  description = "the database instance type"
  type        = string
}

variable "database-instance-identifier" {
  default     = "mt5-mysql-db"
  description = "the database instance identifier"
  type        = string
}

variable "multi-az-deployment" {
  default     = false
  description = "create a standby database instance"
  type        = bool
}

variable "repository-path" {
  default     = "xxxxxxxx"
  description = "the path to this repository"
  type        = string
}

variable "bastion_host_key_pair_name" {
  default = "mt5-linux-server"
}
