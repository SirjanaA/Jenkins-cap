# DevOps- Docker and Jenkins

## Description
This repo is based on Docker and Jenkins.
Main server is build on ubuntu machine t2.medium in eruser102 account:
- Instance : Jenkins-capstone
- Region : us-east-1

## Pre-requisite 
* Install Docker
* Install git 
* Install npm
* Install java
* Install jenkins
* Install aws cli 
- If connecting from the console then start Jenkins-capstone machine and check aws configure: accesskey and secretkey are already in place.
- Deploy server is using eventsapp files, derived from https://github.com/msutton150/eventsappstart.git

## Github
- Clone the repo via: git clone https://github.com/SirjanaA/Jenkins-cap.git 
- This is a public repo has 2 branches: dev and main, all the changes were done via dev branch then merged into main branch.
- Files are located inside Jenkins-cap and ECR -> cpapp 


## Description
- For Docker images, ECR repo is used instead of DockerHub. Example of image creation in DockerHub is also provided.
- cd ~/Jenkins-cap/ECR/cpapp -> this directory has 2 files events-api and events-website. However, only events-api was used to create image via Jenkins.
- Each files has Dockerfile and .dockerignore file.


## Commands for building Docker image in ECR repository
- cd ~/Jenkins-cap/ECR/cpapp/events-api
- docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api
- docker build -t events-api .
- docker tag events-api:latest 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api:1.0
- docker push 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api:1.0

## Commands used to build docker image in Docker Hub (DockerHub only used to practice but wasn't used for Jenkins)
- Docker login -u srzu (username)
- password key pair
- docker build -t srzu/events-api:1.0 .
- docker push srzu/events-api:1.0
- docker build -t srzu/events-website:v2.0 .
- docker push srzu/events-website:v2.0

## Creating image using Jenkinsfile
- For Jenkins to read the files another Dockerfile and .dockerignore was created under Jenkins-cap directory. 
- Docker file path has been edited: " COPY ./ECR/cpapp/events-api/ /app/ " so that the Jenkinsfile can read the command.

To run the Jenkinsfile 

Run this command in EC2 : sudo usermod -aG docker $USER
Restart Jenkins and EC2 server

Using the Jenkinsfile and docker file
ECR repo was created under repo name jenkins v1. 
