# demo-aws-stepfunction
Demo AWS Step Function and Lambdas using Terraform

To use it, you have to install:

1. Install Terraform. (https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Install Terragrunt. (https://terragrunt.gruntwork.io/docs/getting-started/install/)
3. Java Maven. (https://maven.apache.org/install.html)

### Configure AWS CLI

Configure authentication on CLI. Enter access key, secret key and AWS region. For region use: us-east-1
````bash
$ aws configure
````

### Maven Tasks

````bash
$ mvn clean install
````

After build, Check folder `target`, demo-aws-stepfunction-1.0.0-SNAPSHOT.jar this file is use as lambda.

### Terraform Tasks
First update the terraform variables accordingly at: ./var.tf

CD to terraform folder
````bash
$ cd tf-env/dev
````

Init terraform
````bash
$ terragrunt init
````

Apply changes/deploy to AWS
````bash
$ terragrunt apply
````

Destroy changes to AWS
````bash
$ terragrunt destroy
````

### Example JSON for testing Step Function

```` bash
{
	"event": {
		"Records": [
			{
				"s3": {
					"bucket": {
						"name": "flavio-demo01"
					},
					"object": {
						"key": "test-files/test.json"
					}
				}
			}
		]
	}
}
````
