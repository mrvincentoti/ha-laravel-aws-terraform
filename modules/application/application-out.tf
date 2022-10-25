output "alb_dns" {
  value  = aws_alb.laravel-loadbalancer.dns_name
}