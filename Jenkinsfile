pipeline {
    agent any
    
    environment {
        // GitHub CLI folosește automat această variabilă
        GH_TOKEN = credentials('f13e3846-3469-426d-a2f9-096dc6314efa')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                sh '''
                set -e

                export GH_TOKEN=$GH_TOKEN

                python3 -m venv venv
                . venv/bin/activate

                pip install --upgrade pip
                pip install django
                pip install ruff

                if [ -f requirements.txt ]; then
                    pip install -r requirements.txt
                fi

                ruff check . --exclude migrations
                python manage.py test --noinput
                '''
            }
        }
    }

    post {

        success {
            echo '✅ Teste trecute. Încercăm merge automat...'

            sh '''
            export GH_TOKEN=$GH_TOKEN

            CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

            if [ "$CURRENT_BRANCH" = "HEAD" ]; then
                CURRENT_BRANCH=${GIT_BRANCH#*/}
            fi

            echo "Branch detectat: $CURRENT_BRANCH"

            gh pr merge "$CURRENT_BRANCH" --auto --merge \
            || echo "Nu s-a putut face merge automat."
            '''
        }

        failure {
            echo '❌ Teste eșuate. Adăugăm comentariu pe PR...'

            sh '''
            export GH_TOKEN=$GH_TOKEN

            CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

            if [ "$CURRENT_BRANCH" = "HEAD" ]; then
                CURRENT_BRANCH=${GIT_BRANCH#*/}
            fi

            echo "Branch detectat: $CURRENT_BRANCH"

            gh pr comment "$CURRENT_BRANCH" \
              --body "❌ Jenkins CI: Testele au eșuat pe branch-ul $CURRENT_BRANCH. Verifică log-urile Jenkins." \
              || echo "Nu s-a găsit PR deschis pentru acest branch."
            '''
        }

    }
}