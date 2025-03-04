pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub') 
        IMAGE_NAME = 'onuromertunc/rdjenkins' 
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ." 
                }
            }
        }
#onuromertunc
        stage('Login to Docker Hub') {
            steps {
                script {
                    
                    sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }
    }

    post {
        always {
            script {
                
                sh "docker logout"
            }
        }
    }
}
