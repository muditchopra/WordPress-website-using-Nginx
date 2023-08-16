# WordPress-website-using-Nginx

### Prerequisite for local setup

AWS Account
Terraform
Ansible
python3
awscli2

After installing python run this to install required packages.

```bash
cd WordPress-website-using-Nginx
pip install -r requirements.txt
```

NOW Run the aws confiure to access AWS with access and secret key

```bash
aws configure
```

Enter the ACCESS KEY ID then Enter SECRET ACCESS KEY

Now create the ssh key-pair required for with python script
pass the BucketName and AWSregion as arguments

```bash
cd Infra-setup/deploy_script
python add-key-pair.py BucketName AWSregion
```

We can now initialize the terraform but before we need to create the s3 bucket and dynamodb table for terraform backend configuration.

Login to AWS console and Navigate to cloudformation and create the stack with `statelockinfra.yml` present in cloudformationStack folder. Upload the file and create Environment parameter and set value as dev.

Then create ssm_parameter in system manager >> parmeter store
Name: corevpcid , type : string , value : {vpcID}  
Name: vpcsubnet , type : string , value : {subnetId}

##### Terraform Backend and format validation

Now the value of bucketname and table will be passed in ./env/dev/provider.tf
After that initialize the terraform please check that terraform is installed.

```bash
cd ../
cd ./env/dev/
terraform -version
terraform init
terraform fmt
terraform fmt -check -recursive
terraform validate
```

### Terraform Plan

if all the previous cmd's are succeded the we create the plan and output in a file.

```bash
terraform plan -input=false -lock=true -out infra.tfplan
```

### Terraform Apply

Apply the terraform out plan which will create the required infra in AWS account for which you have credentials.

```bash
terraform apply -lock=true -input=false infra.tfplan
```

### Terraform Destroy
