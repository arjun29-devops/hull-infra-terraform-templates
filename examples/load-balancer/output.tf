output "alb_dns" {
  description = "The domain name of ALB"
  value = module.alb.alb_url
}