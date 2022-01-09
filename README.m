Things to do
- Network Diagram : https://github.com/susantoleman/awsvpc/blob/master/FGVM%20AP%20in%20AWS.png
- The scripts will also include the FGVM configuration for HA, N/S and E/W security policy.
- Download terraform app
- Download these terraform script files
- Update your AWS region and AZ in "variables.tf". Search text for "variable region".
- Download your Fortigate VM02 file and put the two files in the same folder as your terraform scripts
- Create AWS access & secret keys, update the details in "terraform.tfvars"
- Create AWS IAM policy and role, name both as "APICall_policy" and "APICall_role", respectively. For IAW policy, copy and paste the JSON format below
{
    "Version": "2012-10-17",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Action": 
            [
              "ec2:Describe*",
              "ec2:AssociateAddress",
              "ec2:AssignPrivateIpAddresses",
              "ec2:UnassignPrivateIpAddresses",
              "ec2:ReplaceRoute"
            ],
            "Resource": "*"
        }
      ]
}
  When creating IAM role, please ensure "APICall_policy" is checked.
- Create EC2 keypairs. Download the keypair into your desktop and update "variables.tf". Search text for "variable keypair"
- Update your two FG VM02 license filename in"variables.tf". Search text for "variable license" and "variable license2"
- After all the files are updated with your own environment configuration, to deploy execute these commands
         - terraform init 
         - terraform plan
         - terraform apply
- You can install the apache2 in "web" and "web2"ec2 instance for external web service. You can use web1-script.sh for web and web2-script.sh for web2.
- To destroy the deployment : terraform destroy
