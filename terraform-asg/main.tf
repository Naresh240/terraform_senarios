provider "aws" {
  shared_credentials_file = "/root/.aws/credentials"
  region = "us-east-1"
}

resource "aws_launch_configuration" "agent-lc" {
    name_prefix = "agent-lc-"
    image_id = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = ["${aws_security_group.websg.id}"]
    user_data = file("install.sh")
    lifecycle {
        create_before_destroy = true
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = "8"
    }
}

resource "aws_cloudformation_stack" "asg" {
  name = "asg-stack"
  template_body = <<STACK
  {
  "Resources": {
    "AutoScaling": {
       "Type": "AWS::AutoScaling::AutoScalingGroup",
       "Properties": {
       "AutoScalingGroupName": "AutoScaling",
       "MinSize": 1,
       "MaxSize": 3,
       "DesiredCapacity": 1,
       "HealthCheckGracePeriod": 300,
       "LaunchConfigurationName": "${aws_launch_configuration.agent-lc.name}",
       "VPCZoneIdentifier": ["subnet-44954165", "subnet-2048551e", "subnet-69438836"]
    },
    "UpdatePolicy": {
        "AutoScalingScheduledAction": {
	"IgnoreUnmodifiedGroupSizeProperties": "true"
        },
        "AutoScalingRollingUpdate": {
        "MaxBatchSize": 4,
        "MinInstancesInService": 2,
        "WaitOnResourceSignals": true,
        "PauseTime": "PT10M"
        }
      }
    },
    "ScheduledActionIn": {
        "Type": "AWS::AutoScaling::ScheduledAction",
        "Properties": {
          "AutoScalingGroupName": {
              "Ref": "AutoScaling"
          },
          "DesiredCapacity": "2",
          "StartTime": "${var.scaleup_start_time}",
          "Recurrence": "${var.scaleup_recurrence}"
        }
      },
     "ScheduledActionOut": {
        "Type": "AWS::AutoScaling::ScheduledAction",
        "Properties": {
          "AutoScalingGroupName": {
              "Ref": "AutoScaling"
          },
          "DesiredCapacity": "1",
          "StartTime": "${var.scaledown_start_time}",
          "Recurrence": "${var.scaledown_recurrence}"
        }
      }
    }
  }
STACK
}

resource "aws_security_group" "websg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

