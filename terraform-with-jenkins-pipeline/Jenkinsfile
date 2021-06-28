pipeline {
	agent {
		docker {
			image 'naresh240/agent-image:latest'
		}
	}
	parameters {
        choice(name: 'action', choices: 'create\ndestroy', description: 'Create/update or destroy the apache-server elb')
        string(name: 'workspace', defaultValue : 'apache-server', description: "Name of the workspace")
	}
	
	stages {
		stage('checkout') {
            		steps {
                		git 'https://github.com/Naresh240/Deploy_AWS_Ansible-Terraform.git'
	    		}
 		}
		stage('Setup') {
    			when {
                	expression { params.action == 'create' }
            		}			
            		steps {
                		script {
                    			currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + " apache-server"
                    			plan = params.workspace + '.plan'
                		}
            		}
        	}
		stage('Create Packer AMI') {
    			when {
                	expression { params.action == 'create' }
            		}
            		steps {
                	withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    		sh 'packer build -debug -var aws_access_key=${AWS_ACCESS_KEY_ID} -var aws_secret_key=${AWS_SECRET_ACCESS_KEY} -var ssh_username="ec2-user" template.json'
    				}
    	    		}
		}
		stage('TF Plan') {
            		when {
                	expression { params.action == 'create' }
            		}
			steps {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                		sh """
				terraform init
				terraform workspace new ${params.workspace} || true
                		terraform workspace select ${params.workspace}
				terraform plan \
					-var access_key=${AWS_ACCESS_KEY_ID} \
					-var secret_key=${AWS_SECRET_ACCESS_KEY} \
                    			-out ${plan}
				"""
				}
			}
		}
		stage('TF Apply') {
			when {
				expression { params.action == 'create' }
			}
			steps {
				script {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh """ 
                    terraform apply -input=false -auto-approve \
				${plan}
                    """
                    }
                }
            }
        }
        stage('TF Destroy') {
          when {
            expression { params.action == 'destroy' }
          }
          steps {
            script {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh """ 
                    terraform workspace select ${params.workspace}
                    terraform destroy -auto-approve \
                        -var access_key=${AWS_ACCESS_KEY_ID} \
					    -var secret_key=${AWS_SECRET_ACCESS_KEY} \
                    """
                    }
                }
            }
	}
    }
}
