# terraform-moduls
## For "dev" environment please use this commands

terraform workspace list # check workspaces
terraform workspace new dev  # if it is not exist
terraform workspace select dev # if it is exist
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

## For "stage" environment please use this commands

terraform workspace list # check workspaces
terraform workspace new stage  # if it is not exist
terraform workspace select stage # if it is exist
terraform plan -var-file="stage.tfvars"
terraform apply -var-file="stage.tfvars"
