output "load_balancer_url" {
  description = "Public url of the load balancer"
  value = module.app.load_balancer_url
}