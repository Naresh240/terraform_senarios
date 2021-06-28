# Autoscaling based on condition of CPU Utilization 

Pre-Requisites:
----------
    -   Install terraform(v0.12)
    -   Install Git
    
Clone the code from github
----------
    https://github.com/VamsiTechTuts/awsautomationrepo.git
    cd terraform-cpumetricsautoscaling

Initilise terraform:
----------
    terraform init
Plan:
----
    terraform plan
Apply:
----
    terraform apply
# Check ELB comes to InService or Not:
![image](https://user-images.githubusercontent.com/58024415/94275970-3b4e7a00-ff65-11ea-92a9-5fe0834571e3.png)

# Check out in UI:
http://web-elb-499150935.us-east-1.elb.amazonaws.com/

![image](https://user-images.githubusercontent.com/58024415/94276120-72bd2680-ff65-11ea-9507-44b59f5a7bf5.png)

Goto Autoscaling group and check Autoscaling conditions attached to our autoscaling. 

Now we need to increase CPU Utilization using below command
    
    for i in 1 2 3 4; do while : ; do : ; done & done
   
Check CPU Utilization using TOP command
    
    top
    
It will scaleup instances as per condition.

Again reduce CPU Utilization by using below command
  
    for i in 1 2 3 4; do kill %$i; done
    
It will scaledown instances as per condition.

CleanUp:
------
    terraform destroy
