output "id" {
  value = aws_instance.ec2box.id
}

output "arn" {
  description = "Amazon Resource Name"
  value       = aws_instance.ec2box.arn
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.ec2box.private_ip
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.ec2box.public_ip
}

output "state" {
  description = "Is this thing on?"
  value       = aws_instance.ec2box.instance_state
}

output "tags" {
  description = "List of attached tags"
  value       = aws_instance.ec2box.tags
}

output "type" {
  description = "What kind of computer is it?"
  value       = aws_instance.ec2box.instance_type
}

output "volume" {
  description = "ID of root storage volume"
  value       = aws_instance.ec2box.root_block_device.0.volume_id
}

output "zone" {
  description = "Availability Zone"
  value       = aws_instance.ec2box.availability_zone
}
