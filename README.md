# Continuous Integration with GitHub Actions, HashiCorp Terraform and Ansible

Deploy WordPress on LEMP Stack in EC2 instance

## Overview

In this scenario, continuous integration of an AWS environment is desired. Infrastructure provision is managed via HashiCorp Terraform. Continuous Integration is managed via GitHub Actions. Configuration is managed by Ansible. By loading the necessary Terraform configuration files into this repository along with two GitHub Workflows, we can Plan and Apply into the target environment.

**NOTE**: GitHub Actions are disabled for this repository to prevent abuse. You can view previous runs [here](/actions).

## Details

This repository contains two GitHub Workflow files:

- [Terraform Plan & Apply](/.github/workflows/tf-plan-apply.yml) - Triggered manually with env specific.

- [Ansible-playbook config](/.github/workflows/ansible-config.yml) - Triggered manually on master branch by providing host name.

## Pre-requisite

## AWS Role

OpenID Connect is an identity layer on top of the OAuth 2.0 protocol. It allows third-party applications to verify the identity of end-users or in our case an AWS role.

AWS Management console -> Navigate to IAM > Identity providers and create a new provider. Select OpenID Connect and add the following:

Provider URL: https://token.actions.githubusercontent.com
Audience: sts.amazonaws.com

Navigate to IAM > Roles and create a new role. Select Web Identity and choose the just created identity provider and Audience same as above. Add the permission by create a new policy and copy the content of [file](./role_iam_permissions.json) and add the following permission to role with creating the inline policy.

- Role Name : workflow-action-role

After the role has been created we are going to add the GitHub repo to the Trust relationships of the role. After editing the trusted entities JSON should look something like this:

We have to manually add the sub repo part, this tells the role which repositories are allowed to assume this role.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::123456789:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:[username]/[REPO_Name]:*"
                }
            }
        }
    ]
}
```

Replace `username` and `Repo_Name` in above policy.

## Secrets

- Make sure you have added the secrets in github repository settings [here](/settings/secrets/actions).

* AWS_REGION = '<region>'
* AWS_ROLE_DEV_ARN = '<Role ARN>'
* BUCKET_NAME = '<Bucket Name>' - bucket will be created and ssh key will be stord in it.

- Add this secret after tf-plan-apply.yml runs successful.

* SSH_PRIVATE_KEY = '<private key>' - The Key is base64 encoded. Download the file from s3 bucket which we used above from AWS Management console, then decode the key with this cmd and copy the content and create the secret.

`base64 -d webserver-key`

## Terraform backend config

I'm using s3 bucket and Dynamodb for terraform state file lock infra.
This can be created with the Cloudformation template [here](/Infra-setup/cloudformationStack/statelockinfra.yml). create Cloudformation stack in AWS management console and pass `dev` as `Environment` parameter.

After successful creation add value of bucket name and Dynamodb table in terraform config [here](/Infra-setup/env/dev/provider.tf).

## Data resource

we need to create some data resources in AWS Management console which we required in terraform configuration. Create ssm_parameter in colsole >> system manager >> parameter store.

- Name: corevpcid , type : string , value : {vpcID}
- Name: vpcsubnet , type : string , value : {subnetId}

## Env specific variable for AWS terraform config

Add the domain name to `domain_name` [here](/Infra-setup/env/dev/main.tf)

## server configuration

The default port on Nginx listens on 80 HTTP.

Default ->

```
port: "80"
owner: "www-data"
group: "www-data"
php_version: "8.1"
domain: "wordpress"
certbot_admin_email: "admin@xyz.com"
mysql_root_password: "MysqlRoot@654321"
mysql_db: "wordpress"
mysql_user: "wordpress"
mysql_password: "Wordpress@654321"
wp_url: "https://wordpress.org/wordpress-6.3.tar.gz"
```

- Update the values specific to you in above config [here](/ansible/group_vars/default.yml) must for HTTPS SSL certificate values to replace.

```
port: "443"
domain: "wordpress"
certbot_admin_email: "admin@xyz.com"
```

if you change the above port and domain then remove the `ignore_errors: true` form [here](/ansible/lemp_stack.yml) task `name: Generate SSL Certificate using Certbot`.

## Destory/delete server (Terraform destroy)

if you want to delete the server or infra we can do it by only changing one line of code in [Terraform Plan & Apply](/.github/workflows/tf-plan-apply.yml) workflow.

- relpace

```
terraform plan -detailed-exitcode -input=false -lock=true -out infra.tfplan
```

- with

```
terraform plan -destroy -detailed-exitcode -input=false -lock=true -out infra.tfplan
```
