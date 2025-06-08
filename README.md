# DevOps- Docker and Jenkins

## Information
This repository utilises Github, Docker and Jenkins.

- All process steps were written in VScode, using the following configurations to connect with GitHub:
    - git config --global user.name "John Doe"
    - git config --global user.email "johndoe@example.com"
- New SSH key pair was generated using: ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
- Changes were committed and pushed to the GitHub repository, which was then cloned onto the deployment server.
- The main server is an Ubuntu t2.medium instance on the eruser102 AWS account:
    - Instance Name: Jenkins-capstone
    - Region: us-east-1
- An existing key pair and security group were used, ensuring port 8080 is open.
- The repository was cloned using: git clone https://github.com/SirjanaA/Jenkins-cap.git 
- This is a public repository with two branches: 'dev' and 'main'. All changes were made on the 'dev' branch and then merged into 'main'.
- Project files are located within the 'Jenkins-cap' directory, and application files are under 'Jenkins-cap/ECR/cpapp'.


## Prerequisites
* Install Docker
* Install git 
* Install npm
* Install java
* Install jenkins
* Install aws cli 
- If connecting from the console then start 'Jenkins-capstone' instance and verify AWS credentials using aws configure. The access key and secret key should already be configured.
- Deploy server uses 'eventsapp' files, derived from https://github.com/msutton150/eventsappstart.git


## Description
- Amazon ECR is used for Docker images instead of Docker Hub. An example of image creation for Docker Hub is also included.
- The directory '~/Jenkins-cap/ECR/cpapp' contains 'events-api' and 'events-website' project files. Only 'events-api' was used to create an image via Jenkins.
- Each file includes a 'Dockerfile' and '.dockerignore' file.


## Building Docker Images for ECR
- Existing ECR repositories were used for pushing images (mutable, AES-256 encryption).

### Building events-api Image
- cd ~/Jenkins-cap/ECR/cpapp/events-api
- docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api
- docker build -t events-api .
- docker tag events-api:latest 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api:1.0
- docker push 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-api:1.0

### Building events-website Image
- cd ~/Jenkins-cap/ECR/cpapp/events-website
- docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-website
- docker build -t events-website .
- docker tag events-website:latest 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-website:1.0
- docker push 441257995286.dkr.ecr.us-east-1.amazonaws.com/events-website:1.0


## Building Docker Images for Docker Hub (Not Used with Jenkins)
- Docker login -u srzu (username)
- password key pair
- docker build -t srzu/events-api:1.0 .
- docker push srzu/events-api:1.0
- docker build -t srzu/events-website:v2.0 .
- docker push srzu/events-website:v2.0

## Building Images with Jenkins
- Signed into Jenkins using the public ip address: http://publicip:8080 and created an admin account (credentials can be provided)
- Configured AWS credentials (access key and secret key) for the eruser102 account within Jenkins.
- Added GitHub and Docker Hub access tokens to Jenkins.
- Created a private ECR repository named jenkins.

## Running groovy script (Jenkinsfile)
- A new 'Dockerfile' and '.dockerignore' file were created in root directory 'Jenkins-cap' for Jenkins to access the application files.
- The Dockerfile's COPY instruction was modified: " COPY ./ECR/cpapp/events-api/ /app/ "
- Ensured Docker was running using docker ps -a.
- Granted the current user Docker access on the EC2 instance: sudo usermod -aG docker $USER
- Restarted Jenkins and the deployment server.
- Inside Jenkinsfile, added credentialsId: 'my-api-key' (Github credentials stored in Jenkins).
- Created a new Jenkins pipeline from SCM (Git): https://github.com/SirjanaA/Jenkins-cap.git 
- Branch */dev -> script path: Jenkinsfile -> save.
- 'Build Now' to build the pipeline, creating a 'v1' image in the jenkins ECR repository.
- Finally, the changes were merged into the main branch.


## Replicating this Project

To replicate this project in a different environment, you will need to modify the environment variables within the Jenkins environment and potentially within the project files themselves (e.g., the Jenkinsfile, Dockerfiles):

* **AWS Account ID:** Replace with your AWS account ID. This is crucial for ECR access.
* **AWS Region:** Ensure that your ECR repository and other AWS resources are located in the same region.
* **ECR Repository URI:** Update the repository URIs with the correct URI for your ECR repository.
* **Image Version:** Adjust the image tags as needed for your versioning scheme.
* **Jenkins Credentials:**  Ensure that the Jenkins instance has the necessary AWS credentials configured to access your ECR repository. These credentials should be securely stored within Jenkins.
* **GitHub Repository:** If you're using a different GitHub repository, update the Git URLs accordingly in the Jenkinsfile and any other relevant locations.


## Stopping Docker Containers
- docker images (List images)
- docker ps -a (List all containers)
- docker stop <ContainerID> (Stop a specific container)
- docker rm <ContainerID> --force (Remove a specific container)

