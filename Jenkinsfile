pipeline {
    agent any

    options {
        timeout(time: 10, unit: 'MINUTES')
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    export PATH=$PATH:/opt/sonar-scanner/bin
                    rm -rf .scannerwork

                    /opt/sonar-scanner/bin/sonar-scanner \
                    -Dproject.settings=.sonar-project.properties \
                    -Dsonar.login=$SONAR_AUTH_TOKEN \
                    -Dsonar.working.directory=/tmp/sonar
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
