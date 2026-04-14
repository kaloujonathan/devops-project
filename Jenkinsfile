pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Analyse SonarQube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    export PATH=$PATH:/opt/sonar-scanner/bin
                    rm -rf .scannerwork

                    /opt/sonar-scanner/bin/sonar-scanner \
                    -Dproject.settings=.sonar-project.properties \
                    -Dsonar.login=$SONAR_TOKEN \
                    -Dsonar.working.directory=/tmp/sonar
                    '''
                }
            }
        }

        stage('Installer les dépendances') {
            steps {
                sh '''
                python3 -m venv venv
                venv/bin/pip install --upgrade pip
                venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Analyse de sécurité') {
            steps {
                sh '''
                venv/bin/pip install bandit safety

                venv/bin/bandit -r . || true
                venv/bin/safety check || true
                '''
            }
        }

        stage('Build Docker') {
            steps {
                sh '''
                docker build -t flask-app .
                '''
            }
        }

        stage('Déploiement Ansible') {
            steps {
                sh '''
                cd ansible
                ansible-playbook -i inventory deploy.yml --ask-become-pass
                '''
            }
        }
    }
}
