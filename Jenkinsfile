pipeline {
    agent any

    options {
        // On met 15 minutes pour être large, mais avec le cache ça prendra 2 minutes
        timeout(time: 15, unit: 'MINUTES') 
        disableConcurrentBuilds()
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                python3 -m venv venv
                venv/bin/pip install --upgrade pip
                # Utilisation du cache pour aller 10x plus vite
                venv/bin/pip install --cache-dir $HOME/.pip-cache -r requirements.txt
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
