# Exemplo create recurse to EC2


terraform workspace new dev
terraform workspace new prod
terraform workspace new stage

terraform workspace select dev
terraform init 
terraform apply -- apply to workscape mode