#!/bin/bash
echo Starting Flask app
cd /home/ubuntu
source venv/bin/activate
cd devops-assignment
gunicorn -w 2 -b 127.0.0.1:8000 app:app
