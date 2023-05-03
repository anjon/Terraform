// Creating IAM role for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// Attaching the role to the IAM policy
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

// Attaching All the subnets for EKS Cluster resource
resource "aws_eks_cluster" "eks_demo" {
  name     = "EKS-Demo"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_eu_central_1a.id,
      aws_subnet.private_eu_central_1b.id,
      aws_subnet.public_eu_central_1a.id,
      aws_subnet.public_eu_central_1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]
}