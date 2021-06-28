Pre-requisites:
------------------
  Install Java
  
  Install Docker
  
  Install Jenkins
  
Step:1
-------------
Build docker image: Image packed with the installations of java, terraform and packer
  
  docker build -t <repo-name>/agent-image:latest .
  
step:2
-------------
Create AWS Credentials with in Jenkins UI

step:3
-------------
Create Jenkins Pipeline Job and keeping Jenkins pipeline script inside the pipeline script section

Now Build jenkins job
