pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Descarcă codul de pe GitHub conform configurării SCM
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                sh '''
                # 1. Creăm mediul virtual pentru izolare
                python3 -m venv venv
                
                # 2. Activăm mediul și instalăm dependințele
                . venv/bin/activate
                pip install --upgrade pip
                pip install ruff
                if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
                
                # 3. Code Linting (Analiza statică)
                echo "--- Rulăm Ruff ---"
                ruff check . --exclude migrations
                
                # 4. Unit Testing (Logica aplicației)
                echo "--- Rulăm Testele Django ---"
                python manage.py test --noinput
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Felicitări! Linting-ul și Testele au trecut cu succes.'
        }
        failure {
            echo '❌ Ceva nu a funcționat. Verifică erorile de mai sus (Ruff sau Django Tests).'
        }
    }
}