# DevOps- Docker and Jenkins

## Info
This repo is based on Docker and Jenkins.
Main server is build on ubuntu machine t2.medium in eruser102 account:
- Instance : Jenkins-capstone
- Region : us-east-1
- Using existing keypair and security group so port 8080 is enabled.
- Clone the repo via: git clone https://github.com/SirjanaA/Jenkins-cap.git 
- This is a public repo with 2 branches: dev and main, all the changes were done via dev branch then merged into main branch.
- Files are located inside Jenkins-cap and ECR -> cpapp 


## Pre-requisite 
* Install Docker
* Install git 
* Install npm
* Install java
* Install jenkins
* Install aws cli 
- If connecting from the console then start Jenkins-capstone machine and check aws configure: accesskey and secretkey are already in place.
- Deploy server is using eventsapp files, derived from https://github.com/msutton150/eventsappstart.git


## Description
- For Docker images, ECR repo is used instead of DockerHub. Example of image creation in DockerHub is also provided.
- cd ~/Jenkins-cap/ECR/cpapp -> this directory has 2 files events-api and events-website. However, only events-api was used to create image via Jenkins.
- Each files has Dockerfile and .dockerignore file.


## Commands for building Docker image in ECR repository
- Used the exsiting ECR images to push the images.( mutable and encryption type: AES-256)

### For events-api
- cd ~/Jenkins-cap/ECR/cpapp/events-api
- docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api
- docker build -t events-api .
- docker tag events-api:latest 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api:1.0
- docker push 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api:1.0

### For events-website
- cd ~/Jenkins-cap/ECR/cpapp/events-website
- docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-website
- docker build -t events-website .
- docker tag events-website:latest 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-website:1.0
- docker push 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-website:1.0


## Image in Docker Hub (DockerHub wasn't used for Jenkins)
- Docker login -u srzu (username)
- password key pair
- docker build -t srzu/events-api:1.0 .
- docker push srzu/events-api:1.0
- docker build -t srzu/events-website:v2.0 .
- docker push srzu/events-website:v2.0

## Creating image using Jenkinsfile
- Signed into Jenkins using the public ip address: http://publicip:8080 and created an admin account (username: admin, password: 26214).
- Added accesskey and secretskey for Jenkins to connect with AWS account (eruser102).
- Also, added github and Dockerhub tokens. 
- Created a repo in ECR private repositories names: jenkins.

## Running groovy script
- For Jenkins to read the files another Dockerfile and .dockerignore was created under Jenkins-cap directory. 
- Docker file path has been edited as: " COPY ./ECR/cpapp/events-api/ /app/ "
- Made sure that docker was running by running docker ps -a
- Run this command in EC2 : sudo usermod -aG docker $USER
- Restart Jenkins and EC2 server
- New pipeline script created from SCM (Git) -> branch */dev -> script path: Jenkinsfile
- Build the pipeline and v1 image was created in jenkins repo in ECR.
- Lastly, the changes were pushed to main branch.

## Commands to stop Docker
- docker images
- docker ps -a
- docker stop <ContainerID>
- docker rm <ContainerID> --force