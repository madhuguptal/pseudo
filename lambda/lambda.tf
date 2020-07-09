data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "refresh.py"
  output_path = "refresh.zip"
}