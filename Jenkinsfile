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

        stage('Security analysis') {
            steps {
                sh '''
                venv/bin/pip install bandit safety
                venv/bin/bandit -r . || true
                venv/bin/safety check || true
                '''
            }
        }

        stage('Run application') {
            steps {
                sh '''
                nohup venv/bin/python app.py > app.log 2>&1 &
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline exécuté avec succès ✅'
        }
        failure {
            echo 'Pipeline échoué ❌'
        }
    }
}
