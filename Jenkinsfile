pipeline {
    agent any

    stages {

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

        stage('Run Application') {
            steps {
                sh '''
                nohup venv/bin/python app.py &
                '''
            }
        }
    }
}
