SHELL := '/bin/bash'


bootstrap:
		aws cloudformation deploy --template-file infrastructure/bootstrap.yaml --stack-name django-serverless-bootstrap --no-fail-on-empty-changeset

docker: Dockerfile
		docker build -f Dockerfile -t django-serverless .

test: 
		sh test.sh

push: 
		ECR_URI=$$(aws ssm get-parameter --name DeploymentEcrUri --query 'Parameter.Value' --output text) && \
		BOOTSTRAP_BUCKET=$$(aws ssm get-parameter --name DeploymentBucketName --query 'Parameter.Value' --output text) && \
		aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $${ECR_URI} && \
		docker tag django-serverless $${ECR_URI} && \
		docker push $${ECR_URI} && \

deploy: 
		BOOTSTRAP_BUCKET=$$(aws ssm get-parameter --name DeploymentBucketName --query 'Parameter.Value' --output text) && \
		aws s3 sync infrastructure/ s3://$${BOOTSTRAP_BUCKET}/infrastructure/
		aws cloudformation deploy --template-file infrastructure/master.yaml --stack-name django-serverless --no-fail-on-empty-changeset --capabilities CAPABILITY_NAMED_IAM


all: bootstrap docker push deploy