pipeline {
    agent any
    
    environment {
        // ID-ul credențialului de tip "Secret Text" creat în Jenkins
        GITHUB_TOKEN = credentials('f13e3846-3469-426d-a2f9-096dc6314efa')
        REPO_URL = "https://api.github.com/repos/dicatalin/curs-devops_proiect-final-aplicatia"
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
                pip install ruff -r requirements.txt
                ruff check . --exclude migrations
                python manage.py test --noinput
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Teste trecute. Se execută Merge automat...'
            sh """
            # Trimitem cererea de Merge prin API-ul GitHub
            # Presupunem că facem merge de pe branch-ul curent în 'main'
            curl -H "Authorization: token ${GITHUB_TOKEN}" \
                 -X POST \
                 -d '{"commit_title": "Auto-merge by Jenkins", "merge_method": "merge"}' \
                 ${REPO_URL}/merges?head=${env.BRANCH_NAME}&base=main
            """
        }
        failure {
            echo '❌ Teste eșuate. Adăugăm comentariu pe PR...'
            sh """
            # Luăm ID-ul ultimului Pull Request deschis pentru acest branch
            PR_NUMBER=\$(curl -H "Authorization: token ${GITHUB_TOKEN}" ${REPO_URL}/pulls?head=dicatalin:${env.BRANCH_NAME} | jq '.[0].number')
            
            # Adăugăm comentariul dacă am găsit un PR
            if [ "\$PR_NUMBER" != "null" ]; then
                curl -H "Authorization: token ${GITHUB_TOKEN}" \
                     -X POST \
                     -d '{"body": "❌ Jenkins: Build-ul a eșuat la etapa de Testare/Linting. Te rog verifică log-urile din consola locală!"}' \
                     ${REPO_URL}/issues/\$PR_NUMBER/comments
            fi
            """
        }
    }
}