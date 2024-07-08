resource "aws_s3_bucket" "s3_trading_robot_code_repo" {
  bucket = "trading-robot-code-repo"

  tags = {
    Name = "bucket to store code and docs"
  }
}

resource "aws_s3_bucket_acl" "s3_trading_robot_code_repo_acl" {
  bucket = aws_s3_bucket.s3_trading_robot_code_repo.id
  acl    = "public-read-write"
}
