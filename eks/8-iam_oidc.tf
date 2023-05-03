data "tls_certificate" "eks_cert" {
  url = aws_eks_cluster.eks_demo.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_openid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_demo.identity[0].oidc[0].issuer
}