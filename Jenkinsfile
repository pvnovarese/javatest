// anchore plugin for jenkins: https://www.jenkins.io/doc/pipeline/steps/anchore-container-scanner/

pipeline {
  environment {
    // "REGISTRY" isn't required if we're using docker hub, I'm leaving it here in case you want to use a different registry
    // REGISTRY = 'registry.hub.docker.com'
    // you need a credential named 'docker-hub' with your DockerID/password to push images
    CREDENTIAL = "docker-hub"
    DOCKER_HUB = credentials("$CREDENTIAL")
    REPOSITORY = "${DOCKER_HUB_USR}/2021-November-Enterprise-Demo"
    TAG = "build-${BUILD_NUMBER}"
    IMAGELINE = "${REPOSITORY}:${TAG} Dockerfile"
} // end environment 
  agent any
  stages {
    stage('Checkout SCM') {
      steps {
        checkout scm
      } // end steps
    } // end stage "checkout scm"
    stage('Build and Push Image') {
      steps {
        script {
          sh """
            docker login -u ${DOCKER_HUB_USR} -p ${DOCKER_HUB_PSW}
            docker build -t ${REPOSITORY}:${TAG} -f ./Dockerfile .
            docker push ${REPOSITORY}:${TAG}
          """
        } // end script
      } // end steps
    } // end stage "build image and push to registry"
    stage('Analyze Image with Anchore plugin') {
      steps {
        writeFile file: 'anchore_images', text: IMAGELINE
        script {
          try {
            // forceAnalyze is a good idea since we're passing a Dockerfile with the image
            anchore name: 'anchore_images', forceAnalyze: 'true', engineRetries: '900'
          } catch (err) {
            // if scan fails, clean up (delete the image) and fail the build
            sh 'docker rmi ${REPOSITORY}:${TAG}'
            sh 'exit 1'
          } // end try
        } // end script 
      } // end steps
    } // end stage "analyze image 1 with anchore plugin"        
    stage('Clean up') {
      // if we succuessfully evaluated the image with a PASS than we don't need the $BUILD_ID tag anymore
      steps {
        sh 'docker rmi ${REPOSITORY}:${TAG1}'
      } // end steps
    } // end stage "clean up"
  } // end stages
} // end pipeline 
