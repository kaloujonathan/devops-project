pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    export PATH=$PATH:/opt/sonar-scanner/bin
                    sonar-scanner \
                    -Dsonar.projectKey=devops-project \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://localhost:9000 \
                    -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
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
                bandit -r . || true
                safety check || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t flask-app .
                '''
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh '''
                cd ansible
                ansible-playbook -i inventory deploy.yml --ask-become-pass
                '''
            }
        }
    }
}
