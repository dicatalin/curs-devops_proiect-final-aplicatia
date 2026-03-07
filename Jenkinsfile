pipeline {
    agent any
    
    environment {
        // gh CLI caută automat variabila GH_TOKEN pentru autentificare
        GH_TOKEN = credentials('f13e3846-3469-426d-a2f9-096dc6314efa')
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Install & Test') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install django
                pip install ruff
                if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
                ruff check . --exclude migrations
                python manage.py test --noinput
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Teste trecute. Încercăm Merge automat...'
            sh 'gh pr merge --auto --merge'
        }
        failure {
            echo '❌ Teste eșuate. Adăugăm comentariu pe PR...'
            // "gh pr comment" detectează automat PR-ul de pe branch-ul curent
            sh 'gh pr comment --body "❌ Jenkins CI: Testele au eșuat. Verifică log-urile în consola Jenkins!" || echo "Nu s-a găsit PR deschis."'
        }
    }
}