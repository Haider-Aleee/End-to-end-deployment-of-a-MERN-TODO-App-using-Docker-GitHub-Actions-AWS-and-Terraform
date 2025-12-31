output "todo_server_ip" {
  description = "Public IP of dev server"
  value       = aws_instance.todo_server.public_ip
}

output "ecr_server_repository_url" {
  description = "ECR repository URL for server"
  value       = aws_ecr_repository.ecr_repo_server.repository_url
}

output "ecr_client_repository_url" {
  description = "ECR repository URL for client"
  value       = aws_ecr_repository.ecr_repo_client.repository_url
}