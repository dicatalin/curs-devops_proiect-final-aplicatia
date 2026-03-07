pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm // Acum va funcționa!
            }
        }
        stage('Linting & Tests') {
            steps {
                sh 'pip install ruff -r requirements.txt'
                sh 'ruff check .'
                sh 'python manage.py test --noinput'
            }
        }
    }
}