# generates an archive from content, a file or a directory of files

# archive import_nas_pa_mysql lamda function
data "archive_file" "zip_python_code_import_nas_pa_mysql" {
  type        = "zip"
  source_dir  = "${path.module}/lamda-function/import_nas_pa_mysql"
  output_path = "${path.module}/lamda-function/import_nas_pa_mysql/import_nas_pa_mysql.zip"
}

# archive exec_sp_load_nas_trading_ods lamda function
data "archive_file" "zip_python_code_exec_sp_load_nas_trading_ods" {
  type        = "zip"
  source_dir  = "${path.module}/lamda-function/exec_sp_load_nas_trading_ods"
  output_path = "${path.module}/lamda-function/exec_sp_load_nas_trading_ods/exec_sp_load_nas_trading_ods.zip"
}

# archive check_ready_to_run_nas lamda function
data "archive_file" "zip_python_code_check_ready_to_run_nas" {
  type        = "zip"
  source_dir  = "${path.module}/lamda-function/check_ready_to_run_nas"
  output_path = "${path.module}/lamda-function/check_ready_to_run_nas/check_ready_to_run_nas.zip"
}

# archive check_for_new_trades_management lamda function
data "archive_file" "zip_python_code_check_for_new_trades_management" {
  type        = "zip"
  source_dir  = "${path.module}/lamda-function/check_for_new_trades_management"
  output_path = "${path.module}/lamda-function/check_for_new_trades_management/check_for_new_trades_management.zip"
}

# archive risk_management lamda function
data "archive_file" "zip_python_code_risk_management" {
  type        = "zip"
  source_dir  = "${path.module}/lamda-function/risk_management"
  output_path = "${path.module}/lamda-function/risk_management/risk_management.zip"
}

# archive check_for_open_trades lamda function
data "archive_file" "zip_python_code_check_for_open_trades" {
  type        = "zip"
  source_dir  = "${path.module}/lamda-function/check_for_open_trades"
  output_path = "${path.module}/lamda-function/check_for_open_trades/check_for_open_trades.zip"
}

# archive check_for_open_trades lamda function
data "archive_file" "zip_python_code_ai_model_live" {
  type        = "zip"
  source_dir  = "${path.module}/lamda-function/ai_model_live"
  output_path = "${path.module}/lamda-function/ai_model_live/ai_model_live.zip"
}

# create lamda function to import trade information from mt5 to mysql staging database
# in terraform ${path.module} is the current directory
resource "aws_lambda_function" "lamda_import_nas_pa_mysql" {
  filename         = "${path.module}/lamda-function/import_nas_pa_mysql/import_nas_pa_mysql.zip"
  function_name    = "import_nas_pa_mysql"
  role             = aws_iam_role.lamda_role.arn
  handler          = "import_nas_pa_mysql.lamda_handler"
  runtime          = "python3.9"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = "30"
  source_code_hash = base64sha256(file("${path.module}/lamda-function/import_nas_pa_mysql/import_nas_pa_mysql.py"))
  publish          = true
  architectures    = ["x86_64"]

  layers = [
    module.lambda_layer.lambda_layer_arn,
  ]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mtc_private_subnet-1.id, aws_subnet.mtc_private_subnet-2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

}

# create lamda function to execute the mysql procedures that loads the staging data into the trading ods database
# in terraform ${path.module} is the current directory
resource "aws_lambda_function" "lamda_exec_sp_load_nas_trading_ods" {
  filename         = "${path.module}/lamda-function/exec_sp_load_nas_trading_ods/exec_sp_load_nas_trading_ods.zip"
  function_name    = "exec_sp_load_nas_trading_ods"
  role             = aws_iam_role.lamda_role.arn
  handler          = "exec_sp_load_nas_trading_ods.lamda_handler"
  runtime          = "python3.9"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = "300"
  source_code_hash = base64sha256(file("${path.module}/lamda-function/exec_sp_load_nas_trading_ods/exec_sp_load_nas_trading_ods.py"))
  publish          = true
  architectures    = ["x86_64"]

  layers = [
    module.lambda_layer.lambda_layer_arn,
  ]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mtc_private_subnet-1.id, aws_subnet.mtc_private_subnet-2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

}

# create lamda function to check if there is new data availible in mt5 (check for new time)
# in terraform ${path.module} is the current directory
resource "aws_lambda_function" "lamda_check_ready_to_run_nas" {
  filename         = "${path.module}/lamda-function/check_ready_to_run_nas/check_ready_to_run_nas.zip"
  function_name    = "check_ready_to_run_nas"
  role             = aws_iam_role.lamda_role.arn
  handler          = "check_ready_to_run_nas.lamda_handler"
  runtime          = "python3.9"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = "30"
  source_code_hash = base64sha256(file("${path.module}/lamda-function/check_ready_to_run_nas/check_ready_to_run_nas.py"))
  publish          = true
  architectures    = ["x86_64"]

  layers = [
    module.lambda_layer.lambda_layer_arn,
  ]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mtc_private_subnet-1.id, aws_subnet.mtc_private_subnet-2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

}

# create lamda function to check if any new trades need to be opened from the data imported into mysql
# in terraform ${path.module} is the current directory
resource "aws_lambda_function" "lamda_check_for_new_trades_management" {
  filename         = "${path.module}/lamda-function/check_for_new_trades_management/check_for_new_trades_management.zip"
  function_name    = "check_for_new_trades_management"
  role             = aws_iam_role.lamda_role.arn
  handler          = "check_for_new_trades_management.lamda_handler"
  runtime          = "python3.9"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = "30"
  source_code_hash = base64sha256(file("${path.module}/lamda-function/check_for_new_trades_management/check_for_new_trades_management.py"))
  publish          = true
  architectures    = ["x86_64"]

  layers = [
    module.lambda_layer.lambda_layer_arn,
  ]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mtc_private_subnet-1.id, aws_subnet.mtc_private_subnet-2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

}

# create lamda function to manage riks this lamda will check for trades to close according to risk management rules
# in terraform ${path.module} is the current directory
resource "aws_lambda_function" "lamda_risk_management" {
  filename         = "${path.module}/lamda-function/risk_management/risk_management.zip"
  function_name    = "risk_management"
  role             = aws_iam_role.lamda_role.arn
  handler          = "risk_management.lamda_handler"
  runtime          = "python3.9"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = "30"
  source_code_hash = base64sha256(file("${path.module}/lamda-function/risk_management/risk_management.py"))
  publish          = true
  architectures    = ["x86_64"]

  layers = [
    module.lambda_layer.lambda_layer_arn,
  ]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mtc_private_subnet-1.id, aws_subnet.mtc_private_subnet-2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

}

# create lamda function to check if there are any current open trades 
# in terraform ${path.module} is the current directory
resource "aws_lambda_function" "lamda_check_for_open_trades" {
  filename         = "${path.module}/lamda-function/check_for_open_trades/check_for_open_trades.zip"
  function_name    = "check_for_open_trades"
  role             = aws_iam_role.lamda_role.arn
  handler          = "check_for_open_trades.lamda_handler"
  runtime          = "python3.9"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = "30"
  source_code_hash = base64sha256(file("${path.module}/lamda-function/check_for_open_trades/check_for_open_trades.py"))
  publish          = true
  architectures    = ["x86_64"]

  layers = [
    module.lambda_layer.lambda_layer_arn,
  ]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mtc_private_subnet-1.id, aws_subnet.mtc_private_subnet-2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

}

# create lamda function to run ai model on destination table and populate ai model table
# in terraform ${path.module} is the current directory
resource "aws_lambda_function" "ai_model_live" {
  filename         = "${path.module}/lamda-function/ai_model_live/ai_model_live.zip"
  function_name    = "ai_model_live"
  role             = aws_iam_role.lamda_role.arn
  handler          = "ai_model_live.lamda_handler"
  runtime          = "python3.9"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = "60"
  source_code_hash = base64sha256(file("${path.module}/lamda-function/ai_model_live/ai_model_live.py"))
  publish          = true
  architectures    = ["x86_64"]

  layers = [
    module.lambda_layer.lambda_layer_arn,
  ]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mtc_private_subnet-1.id, aws_subnet.mtc_private_subnet-2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

}

output "terraform_aws_role_output" {
  value = aws_iam_role.lamda_role.name
}

output "terraform_aws_role_arn_output" {
  value = aws_iam_role.lamda_role.arn
}

output "terraform_logging_arn_output" {
  value = aws_iam_policy.iam_policy_for_lamda.arn
}


#############################################
# Lambda Layer (install Python dependencies)
#############################################

module "lambda_layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  create_layer = true

  layer_name               = "mysql-layer"
  description              = "layer for mysql python connector"
  compatible_runtimes      = ["python3.9"]
  compatible_architectures = ["x86_64"]

  runtime = "python3.9" # Runtime is required for "pip install" to work

  source_path = [
    {
      path             = "${path.module}/lamda-layers/"
      pip_requirements = false    # Will run "pip install" with default "requirements.txt" from the path
      prefix_in_zip    = "python" # required to get the path correct
    }
  ]

  tags = {
    Pattern = "terraform-lambda-layer"
    Module  = "lambda_layer"
  }
}

