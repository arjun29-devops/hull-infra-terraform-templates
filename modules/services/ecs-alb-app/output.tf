output "load_balancer_url" {
  description = "Public url of the load balancer"
  value = module.alb.alb_url
}