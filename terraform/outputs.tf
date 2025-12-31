output "todo_server_ip" {
  description = "Public IP of dev server"
  value       = aws_instance.todo_server.public_ip
}