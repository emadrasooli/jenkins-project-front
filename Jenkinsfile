pipeline {
  agent any

  environment {
    REGISTRY = "10.5.0.9:5000"     
    IMAGE_REPO = "${REGISTRY}/jenkins-project-front"
    NODE_VERSION = "24"
    YARN_VERSION = "4.12.0"
  }

  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script { COMMIT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim() }
        echo "Commit: ${COMMIT}"
      }
    }

    stage('Prepare Node & Yarn') {
      steps {
        sh '''
          corepack enable || true
          corepack prepare yarn@${YARN_VERSION} --activate
          node --version || true
          yarn --version || true
        '''
      }
    }

    stage('Install') {
      steps {
        sh 'yarn install --immutable'
      }
    }

    stage('Build') {
      steps {
        sh 'yarn build'
      }
    }

    stage('Docker Build') {
      steps {
        script {
          def tag = "${IMAGE_REPO}:${COMMIT}"
          def latest = "${IMAGE_REPO}:latest"
          sh "docker build --pull -t ${tag} ."
          sh "docker tag ${tag} ${latest}"
          sh "docker images --format 'table {{.Repository}}\\t{{.Tag}}\\t{{.Size}}' | grep ${IMAGE_REPO} || true"
        }
      }
    }

    stage('Docker Push to Local Registry') {
      steps {
        script {
          sh """
            docker push ${IMAGE_REPO}:${COMMIT}
            docker push ${IMAGE_REPO}:latest
          """
        }
      }
    }

    stage('Optional Deploy') {
      steps {
        echo "Deploy step is optional — you can pull and run this image on target servers."
        // Example (commented) to run on same server:
        // add a new commit on main branch to test deployment
        // sh "docker rm -f my-nextjs-app || true"
        // sh "docker run -d --name my-nextjs-app -p 80:3000 ${IMAGE_REPO}:latest"
      }
    }
  }

  post {
    success {
      echo "Build and push successful: ${IMAGE_REPO}:${COMMIT}"
    }
    failure {
      echo "Pipeline failed"
    }
  }
}
