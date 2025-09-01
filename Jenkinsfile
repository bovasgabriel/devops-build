pipeline {
    agent any

    environment {
        DOCKER_HUB = "bovasgabriel"
        DOCKER_CRED = credentials('dockerhub')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}",
                    url: 'https://github.com/bovasgabriel/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        IMAGE = "${DOCKER_HUB}/dev:latest"
                    } else if (env.BRANCH_NAME == 'master') {
                        IMAGE = "${DOCKER_HUB}/prod:latest"
                    }
                    sh "docker build -t ${IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh """
                        echo $DOCKER_CRED_PSW | docker login -u $DOCKER_CRED_USR --password-stdin
                        docker push ${IMAGE}
                    """
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                sh "./deploy.sh"
            }
        }
    }

    triggers {
        githubPush()
    }
}
