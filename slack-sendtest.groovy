pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }

    post {
        success {
            slackSend channel: '#jenkinstest', message: "✅ Build başarılı: ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${env.BUILD_URL}"
        }
        failure {
            slackSend channel: '#jenkinstest', message: "❌ Build başarısız: ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${env.BUILD_URL}"
        }
    }
}
