variable "ecs_root_password" {
  description = "ECS root password (simpler to configure than key pairs)"
  default = "YourR00tP@ssword"
}

variable "ecs_instance_type" {
  description = "ECS instance type (e.g. ecs.t5-lc2m1.nano, ecs.xn4.small, ...)"
  default = "ecs.t5-lc2m1.nano"
  // Cheapest instance type (1 cpu, 0.5GB ram)
}

variable "ecs_max_bandwidth_out" {
  description = "Maximum egress bandwidth allowed for the ECS in MB."
  default = "1"
}