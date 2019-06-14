data "aws_iam_policy_document" "terraform_enterprise_global" {
  statement {
    sid = "GlobalPermissions"

    actions = [
      "ec2:AcceptVpcPeeringConnection",        # supports resource level permissions (conditions not functional with current config)
      "ec2:AllocateAddress",
      "ec2:AssociateAddress",
      "ec2:AssociateDhcpOptions",
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:AttachVpnGateway",
      "ec2:CreateDhcpOptions",
      "ec2:CreateInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:CreateNetworkAcl",
      "ec2:CreateNetworkAclEntry",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateVpc",
      "ec2:CreateVpcPeeringConnection",        # supports resource level permissions (conditions not functional with current config)
      "ec2:DeleteNatGateway",
      "ec2:DeleteNetworkAclEntry",             # supports resource level permissions (default nacl deletes all entries on apply)
      "ec2:DeleteSubnet",
      "ec2:DeleteVpc",
      "ec2:Describe*",
      "ec2:DetachInternetGateway",
      "ec2:DetachVpnGateway",
      "ec2:DisableVgwRoutePropagation",
      "ec2:DisassociateAddress",
      "ec2:DisassociateRouteTable",
      "ec2:EnableVgwRoutePropagation",
      "ec2:ModifyVpcAttribute",
      "ec2:ModifyVpcPeeringConnectionOptions",
      "ec2:ReleaseAddress",
      "ec2:ReplaceNetworkAclAssociation",
      "ec2:ReplaceNetworkAclEntry",
      "ec2:ReplaceRoute",
      "ec2:ReplaceRouteTableAssociation",
      "route53:AssociateVPCWithHostedZone",
      "route53:DisassociateVPCFromHostedZone",
      "route53:GetChange",
      "route53:GetHostedZone",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "terraform_enterprise_global" {
  name   = "terraform_${var.environment}${var.deployment_group}_${var.stack_name}_global"
  policy = "${data.aws_iam_policy_document.terraform_enterprise_global.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_enterprise_global" {
  user       = "${aws_iam_user.terraform_enterprise.name}"
  policy_arn = "${aws_iam_policy.terraform_enterprise_global.arn}"
}
