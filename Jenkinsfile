pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm // Acum va funcționa!
            }
        }
        stage('Install & Test') {
    steps {
        sh '''
        # 1. Creăm mediul virtual dacă nu există
        python3 -m venv venv
        
        # 2. Activăm mediul și instalăm tot ce trebuie
        # Folosim . venv/bin/activate pentru a rula restul comenzilor în interior
        . venv/bin/activate
        pip install --upgrade pip
        pip install ruff
        pip install -r requirements.txt
        
        # 3. Rulăm Linting
        echo "Rulăm Ruff..."
        ruff check . --exclude migrations
        
        # 4. Rulăm Testele
        echo "Rulăm Testele Django..."
        python manage.py test --noinput
        '''
    }
}
        }
    }
}