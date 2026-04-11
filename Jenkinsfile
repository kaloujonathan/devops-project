pipeline {
    agent any

    stages {

        stage('Clonage GitHub') {
            steps {
                git 'https://github.com/kaloujonathan/devops-projets.git'
            }
        }

        stage('Setup environment') {
            steps {
                sh '''
                python3 -m venv venv
                venv/bin/pip install --upgrade pip
                venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Security check (basic)') {
            steps {
                sh '''
                venv/bin/pip install bandit safety
                bandit -r . || true
                safety check || true
                '''
            }
        }

        stage('Run App') {
            steps {
                sh '''
                nohup venv/bin/python app.py &
                '''
            }
        }
    }
}
