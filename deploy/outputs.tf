output "fastapi_optimum_onnx_amd_dns_name" {
  value = aws_lb.fastapi_optimum_onnx_amd.dns_name
}

output "fastapi_optimum_onnx_arm_dns_name" {
  value = aws_lb.fastapi_optimum_onnx_arm.dns_name
}

output "fastapi_trivial_amd_dns_name" {
  value = aws_lb.fastapi_trivial_amd.dns_name
}

output "fastapi_trivial_arm_dns_name" {
  value = aws_lb.fastapi_trivial_arm.dns_name
}