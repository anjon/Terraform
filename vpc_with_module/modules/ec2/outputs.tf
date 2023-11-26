output "instance" {
  value = aws_instance.web.*.id
}