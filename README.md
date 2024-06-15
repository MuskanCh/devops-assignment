# Assignment-DevOps Engineer
Explaining all the steps and process of the task given.
## Task 
## 1. Set Up an EC2 Instance:
The ec2 instance is of t2.micro type and volume size 20GiB.
To connect with ec2 the ssh command that has been used : 
```sh
chmod 400 "devopsassignment.pem"
ssh -i "devopsassignment.pem" ec2user@ec2-x.x.x.x.ap-south-1.compute.amazonaws.com
```
Updated the packages, installing python and pip and install nginx
```
sudo apt update
sudo apt upgrade
sudo apt install python3 python3-pip
sudo apt install nginx
```
## 2. Deploy a Simple Web Application:
Create a simple Python Flask application that returns "Hello World!" with Gunicorn as the WSGI server
```
python3 -m venv venv
source venv/bin/activate
pip install Flask
pip install gunicorn
```
Then added the simple code written saying Hello World! in app.py can be found in the repo
The file can be run by the command:
```
gunicorn -w 2 -b 0.0.0.0:8000 app:app
```
To make the service available without sshing the the server and run it, so making a service file to run the app on boot of the server. 
```
sudo vim /etc/systemd/system/app.service
```
adding the code to make the service available adding the code the in the start.sh can be found in the repo
```
[Unit]
Description=Gunicorn Flask Application
After=network.target
After=systemd-user-sessions.service
After=network-online.target

[Service]
User=ubuntu
Group=ubuntu
Type=simple
ExecStart=/home/ubuntu/devops-assignment/start.sh
TimeoutSec=30
Restart=on-failure
RestartSec=15
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
```

to enable the app.service
```
sudo systemctl enable app
```

Configure Nginx as a reverse proxy to forward requests to the Gunicorn server.
The configuration added in the nginx is in the file reverse-proxy.conf added by the command:
```
sudo vi reverse-proxy.conf
```
Now restart the Nginx
```
sudo systemctl restart nginx
```
## 3. Configure S3 for Static File Hosting:
Created the s3 bucket with name devops-assignment-muskan. A brief introduction can be accessed via link
```sh
https://devops-assignment-muskan.s3.amazonaws.com/muskan.txt
```
bucket policy created:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::devops-assignment-muskan/muskan.txt"
        }
    ]
}
```
## 4. Set Up a CI/CD Pipeline:
The pipeline can be found as .github/workflows/main.yaml. The pipeline first clone the repository then 
install flask and gunicorn then we update the code in present in the ec2 instance, as i have cloned the git repo there,
to update the code we basically take the latest pull.
And as the ec2 can access the bucket on s3 we update start.sh and push it to the s3 bucket.

## 5. Manage Access and Permissions:
IAM policies to ensure the EC2 instance can interact with the S3 bucket that is created:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::devops-assignment-muskan/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::devops-assignment-muskan"
        }
    ]
}
```
IAM Role to ensure the EC2 instance can interact with the S3 bucket that is created:


Added the above policy while creating the role. By selecting the trusted entity type as aws service and use case as EC2 just add the above policy.
Then apply it to the ec2 instance that was created in the first step.

Security group configuration for the EC2 instance to allow web traffic on port 80
![Screenshot](images/screenshot.png)


## 6. Automation and Scheduling:
Cron job script on the EC2 instance to check the application health:
Added the file checkHealth.sh to check the health of the url 
to run this file every 5 min add this cron
```
crontab -e
# then add this to cron
*/5 * * * * /home/ubuntu/checkHealth.sh
```

















