pipeline {
    agent any

    options {
        timeout(time: 15, unit: 'MINUTES') // On met 15 par sécurité, mais ça ira plus vite
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
                    # On ne supprime .scannerwork que si nécessaire pour gagner du temps
                    /opt/sonar-scanner/bin/sonar-scanner \
                    -Dproject.settings=.sonar-project.properties \
                    -Dsonar.login=$SONAR_AUTH_TOKEN \
                    -Dsonar.working.directory=/tmp/sonar || true
                    '''
                }
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                # On utilise le cache de pip pour ne pas retélécharger Flask à chaque fois
                python3 -m venv venv
                venv/bin/pip install --upgrade pip
                venv/bin/pip install --cache-dir /var/lib/jenkins/.cache/pip -r requirements.txt
                '''
            }
        }

        stage('Security scan') {
            steps {
                sh '''
                # On installe bandit/safety seulement s'ils ne sont pas là
                venv/bin/pip install bandit safety
                venv/bin/bandit -r . || true
                venv/bin/safety check || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                # Docker utilise son propre cache automatiquement (très rapide)
                docker build -t flask-app .
                '''
            }
        }

        stage('Deploy with Ansible') {
            steps {
                // Pour la soutenance, on peut passer le mot de passe via un fichier pour éviter le blocage
                sh '''
                cd ansible
                ansible-playbook -i inventory deploy.yml --ask-become-pass --extra-vars "ansible_sudo_pass=ton_mot_de_passe"
                '''
            }
        }
    }
}
