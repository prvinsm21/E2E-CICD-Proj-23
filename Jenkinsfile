pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = "prvinsm21"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        IMAGE_NAME = "prvinsm21/resturantsite:${BUILD_NUMBER}"
    }
    stages {
        stage ('Git checkout') {
            steps {
                sh 'echo Passed'
            }
        }
        stage ('Code Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage ('Unit Testing') {
            steps {
                sh 'mvn test'
            }
        }
        stage ('Integration Testing') {
            steps {
                sh 'mvn clean verify -DskipUnitTests'
            }
        }
        stage ('Build stage') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage ('Static Code analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage ('Build and Push Docker image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME .'
                    def dockerImage = docker.image("${IMAGE_NAME}")
                    docker.withRegistry('https://index.docker.io/v1/', "dockerhub") {
                    dockerImage.push()
                }
            }
        }

    }
}