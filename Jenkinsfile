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
        sh '''
        # Aflăm branch-ul curent chiar dacă suntem în detached HEAD
        CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
        if [ "$CURRENT_BRANCH" = "HEAD" ]; then
            CURRENT_BRANCH=${GIT_BRANCH#*/} # Extrage branch-ul din variabila Jenkins
        fi
        
        gh pr merge $CURRENT_BRANCH --auto --merge || echo "Nu s-a putut face merge automat."
        '''
    }
    failure {
        echo '❌ Teste eșuate. Adăugăm comentariu pe PR...'
        sh '''
        # Identificăm branch-ul pentru GitHub CLI
        CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
        if [ "$CURRENT_BRANCH" = "HEAD" ]; then
             # În Jenkins, GIT_BRANCH are formatul origin/development, noi vrem doar development
            CURRENT_BRANCH=${GIT_BRANCH#*/}
        fi

        echo "Detectat branch: $CURRENT_BRANCH"
        
        # Îi spunem lui gh exact ce branch să caute
        gh pr comment $CURRENT_BRANCH --body "❌ Jenkins CI: Testele au eșuat pe branch-ul $CURRENT_BRANCH. Verifică log-urile în consola Jenkins!" || echo "Nu s-a găsit PR deschis pentru $CURRENT_BRANCH."
        '''
    }
}}