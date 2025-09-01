pipeline {
  agent any

  environment {
    DOCKER_USER = 'bovasgabriel'
    DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'  
    DEPLOY_SERVER = '43.205.241.187'
    EC2_SSH_CREDENTIALS = 'ec2-ssh-key' 
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build') {
      steps {
        script {
          // Build image tagged with build number
          if (env.BRANCH_NAME == 'master') {
            sh "docker build -t ${DOCKER_USER}/prod:${env.BUILD_NUMBER} ."
          } else {
            sh "docker build -t ${DOCKER_USER}/dev:${env.BUILD_NUMBER} ."
          }
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          withDockerRegistry([ credentialsId: env.DOCKERHUB_CREDENTIALS, url: '' ]) {
            if (env.BRANCH_NAME == 'master') {
              sh "docker tag ${DOCKER_USER}/prod:${env.BUILD_NUMBER} ${DOCKER_USER}/prod:latest"
              sh "docker push ${DOCKER_USER}/prod:${env.BUILD_NUMBER}"
              sh "docker push ${DOCKER_USER}/prod:latest"
            } else {
              sh "docker tag ${DOCKER_USER}/dev:${env.BUILD_NUMBER} ${DOCKER_USER}/dev:latest"
              sh "docker push ${DOCKER_USER}/dev:${env.BUILD_NUMBER}"
              sh "docker push ${DOCKER_USER}/dev:latest"
            }
          }
        }
      }
    }

    stage('Deploy (master only)') {
      when { branch 'master' }
      steps {
        script {
          // DEPLOY_SERVER must be set in job (see instructions below)
          if (!env.DEPLOY_SERVER) {
            error "DEPLOY_SERVER not set - please configure it in the job's Branch property or global env."
          }

          withCredentials([sshUserPrivateKey(credentialsId: env.EC2_SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY')]) {
            // copy deploy_remote.sh to server and run it with the prod image tag
            sh """
              scp -o StrictHostKeyChecking=no -i ${SSH_KEY} deploy_remote.sh ubuntu@${DEPLOY_SERVER}:/home/ubuntu/deploy_remote.sh
              ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ubuntu@${DEPLOY_SERVER} 'chmod +x ~/deploy_remote.sh && ~/deploy_remote.sh ${DOCKER_USER}/prod:${env.BUILD_NUMBER}'
            """
          }
        }
      }
    }
  }

  post {
    always { sh 'docker logout || true' }
    success { echo "Pipeline succeeded for ${env.BRANCH_NAME}" }
    failure { echo "Pipeline FAILED for ${env.BRANCH_NAME}" }
  }
}

