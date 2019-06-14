resource "aws_sns_topic_policy" "isg-sns-request-crossaccount" {
  arn ="${aws_sns_topic.ProdCtrlsRequestTopicARN.arn}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement":[{
    "Sid": "default",
    "Effect": "Allow",
    "Principal": {"AWS":"*"},
    "Action": [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic"
    ],
    "Resource": [
    "${aws_sns_topic.ProdCtrlsRequestTopicARN.arn}"
    ]
  }]
}
EOF
}

resource "aws_sns_topic_policy" "isg-sns-response-crossaccount" {
  arn ="${aws_sns_topic.ProdCtrlsResponseTopicARN.arn}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement":[{
    "Sid": "default",
    "Effect": "Allow",
    "Principal": {"AWS":"*"},
    "Action": [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic"
    ],
    "Resource": [
    "${aws_sns_topic.ProdCtrlsResponseTopicARN.arn}"
    ]
  }]
}
EOF
}


resource "aws_sns_topic" "ProdCtrlsRequestTopicARN" {
  name = "com-hmhco-isg-${var.tag_stage}-pcs-ProdCtrlsRequestTopic"
}

resource "aws_sns_topic" "ProdCtrlsResponseTopicARN" {
  name = "com-hmhco-isg-${var.tag_stage}-pcs-ProdCtrlsResponseTopic"
}
