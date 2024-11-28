variable "instance_type" {
  description = "Tipo de máquina EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Chave SSH para acessar a instância"
  type        = string
}
