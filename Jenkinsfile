pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {

        stage('Clone repo') {
            steps {
                checkout scm
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                python3 -m venv venv
                venv/bin/pip install --upgrade pip
                venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Security scan') {
            steps {
                sh '''
                venv/bin/pip install bandit safety
                venv/bin/bandit -r . || true
                venv/bin/safety check || true
                '''
            }
        }

        stage('Run app') {
            steps {
                sh '''
                nohup venv/bin/python app.py > output.log 2>&1 &
                '''
            }
        }
    }
}
