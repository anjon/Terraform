// Creating iam role for eks nodes
resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

// Attaching role to iam policy
resource "aws_iam_role_policy_attachment" "nodes_AmazonEKS_WorkerNode_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_iam_role_policy_attachment" "nodes_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

// Creating EKS Node groups resources
resource "aws_eks_node_group" "eks_private_nodes" {
  cluster_name    = aws_eks_cluster.eks_demo.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  subnet_ids = [
    aws_subnet.private_eu_central_1a.id,
    aws_subnet.private_eu_central_1a.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  # taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_AmazonEKS_WorkerNode_Policy,
    aws_iam_role_policy_attachment.nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly
  ]

  # resource "aws_launch_template" "eks-with-disks" {
  #   name = "eks-with-disks"

  #   key_name = "local-provisioner"

  #   block_device_mappings {
  #     device_name = "/dev/xvdb"

  #     ebs {
  #       volume_size = 50
  #       volume_type = "gp2"
  #     }
  #   }
  # }

}