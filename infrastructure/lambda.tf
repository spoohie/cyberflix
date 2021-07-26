module "faceblurer_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "faceblurer"
  description   = "My awesome faceblurer"
  handler       = "face_blurer.lambda_handler"
  runtime       = "python3.8"
  layers = ["arn:aws:lambda:eu-central-1:770693421928:layer:Klayers-python38-Pillow:10"]
  timeout = "10"

  source_path = "../src"

  tags = var.tags

  environment_variables = {
    destination_bucket = aws_s3_bucket.destination.bucket
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.faceblurer_lambda.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.input.id

  lambda_function {
    lambda_function_arn = module.faceblurer_lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_iam_policy" "faceblurer" {
  name        = "faceblurer"
  description = "Policy for accessing DetectFaces"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":"rekognition:DetectFaces",
         "Resource":"*"
      },{
        "Effect":"Allow",
        "Action":[
            "s3:GetObject*",
            "s3:GetBucket*",
            "s3:List*"
        ],
        "Resource":[
            "${aws_s3_bucket.input.arn}",
            "${aws_s3_bucket.input.arn}/*"
        ]
      },{
        "Effect":"Allow",
        "Action":[
            "s3:PutObject*",
        ],
        "Resource":[
            "${aws_s3_bucket.destination.arn}",
            "${aws_s3_bucket.destination.arn}/*"
        ]
      }
   ]
  })
}

resource "aws_iam_role_policy_attachment" "faceblurer" {
  role       = module.faceblurer_lambda.lambda_role_name
  policy_arn = aws_iam_policy.faceblurer.arn
}