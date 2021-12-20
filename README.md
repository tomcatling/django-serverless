This is an exploration of deploying a Dockerised Django on Lambda. The backend is serverless Aurora PostgreSQL, or postgres docker for local testing. 

It's based on a few blogs and reference architectures:

* https://sixfeetup.com/blog/serverless-django-aws
* https://chariotsolutions.com/blog/post/getting-started-with-lambda-container-images/
* https://aripalo.com/blog/2020/aws-lambda-container-image-support/
* https://markgituma.medium.com/deploying-django-docker-images-to-aws-lambda-container-5b3d9faf6982
* https://bl.ocks.org/magnetikonline/c314952045eee8e8375b82bc7ec68e88

* https://github.com/awslabs/aws-cloudformation-templates/blob/master/community/services/RDS/aurora-serverless/template.yml
* https://levelup.gitconnected.com/create-aws-rds-mysql-instance-with-a-secured-master-password-using-cloudformation-template-c3a767062972

I use `apig-wsgi` to interface the Django application with Lambda.