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
        stage ('Update Deployment File') {
            environment {
                GIT_REPO_NAME = "E2E-CICD-Proj-3"
                GIT_USER_NAME = "prvinsm21"
            }
            steps {
                withCredentials([string(credentialsId: 'git-push', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "prvinsm21@gmail.com"
                    git config user.name "Macko"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" manifest-files/deployment.yml
                    git add manifest-files/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:master
                '''
                }
            }
        }
}
}