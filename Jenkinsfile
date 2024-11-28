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

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Docker Hub'a giriş yap
                    sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Docker imajını Docker Hub'a push et
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }
    }

    post {
        always {
            script {
                // Docker login oturumunu kapat
                sh "docker logout"
            }
        }
    }
}
