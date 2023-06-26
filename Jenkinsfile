pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials("docker-hub")
    }
    stages {
        stage ("code_checkout") {
            steps {
                git branch: 'master', url: 'https://github.com/marieswarank95/nodejs_app.git'
            }
        }
        stage ("Build") {
            steps {
                sh '''echo "Building docker image"
                docker build -t marieswaran/python:${BUILD_NUMBER} .'''
            }
        }
        stage ("docker image upload") {
            steps {
                sh '''echo $DOCKER_HUB_CREDENTIALS_PSW | docker login --username $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                docker  push marieswaran/python:${BUILD_NUMBER}'''
            }
        }
        stage ("clean up") {
            steps {
                sh 'docker rmi marieswaran/python:${BUILD_NUMBER}'
            }
        }
        stage ("ECS deployment") {
            steps {
                sh 'sh ecs-service-deployment.sh'
            }
        }
    }
}