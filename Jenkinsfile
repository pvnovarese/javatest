pipeline {
  environment {
    //
    // "REGISTRY" isn't required if we're using docker hub, I'm leaving it here in case you want to use a different registry
    // REGISTRY = 'registry.hub.docker.com'
    //
    // you need a credential named 'docker-hub' with your DockerID/password to push images
    CREDENTIAL = "docker-hub"
    DOCKER_HUB = credentials("$CREDENTIAL")
    REPOSITORY = "${DOCKER_HUB_USR}/2021-november-enterprise-demo"
    TAG = "build-${BUILD_NUMBER}"
    IMAGELINE = "${REPOSITORY}:${TAG} Dockerfile"
    //
    // we will need these if we're using anchore-cli
    // we'll need the anchore credential to pass the user
    // and password to anchore-cli so it can upload the results
    // ANCHORE_CREDENTIAL = "AnchoreJenkinsUser"
    // use credentials to set ANCHORE_USR and ANCHORE_PSW
    // ANCHORE = credentials("${ANCHORE_CREDENTIAL}")
    // api endpoint of your anchore instance
    // ANCHORE_URL = "http://anchore3-priv.novarese.net:8228/v1"
    //
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
        sh """
          docker login -u ${DOCKER_HUB_USR} -p ${DOCKER_HUB_PSW}
          docker build -t ${REPOSITORY}:${TAG} --pull -f ./Dockerfile .
          docker push ${REPOSITORY}:${TAG}
        """
      } // end steps
    } // end stage "build image and push to registry"
    
    stage('Analyze Image with Anchore plugin') {
      steps {
        writeFile file: 'anchore_images', text: IMAGELINE
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          anchore name: 'anchore_images', forceAnalyze: 'true', engineRetries: '900'
        }
        //script {
        //  try {
        //    //
        //    // anchore plugin for jenkins: https://www.jenkins.io/doc/pipeline/steps/anchore-container-scanner/
        //   //
        //    // forceAnalyze is a good idea since we're passing a Dockerfile with the image
        //    anchore name: 'anchore_images', forceAnalyze: 'true', engineRetries: '900'
        //    //
        //    // if we want to use anchore-cli instead we can do this:
        //    //sh """
        //    //  anchore-cli --url ${ANCHORE_URL} --u ${ANCHORE_USR} --p ${ANCHORE_PSW} image add --force --dockerfile Dockerfile-1 --noautosubscribe ${REPOSITORY}:${TAG1}
        //    //  anchore-cli --url ${ANCHORE_URL} --u ${ANCHORE_USR} --p ${ANCHORE_PSW} image wait ${REPOSITORY}:${TAG1}
        //    //  anchore-cli --url ${ANCHORE_URL} --u ${ANCHORE_USR} --p ${ANCHORE_PSW} evaluate check ${REPOSITORY}:${TAG1}
        //    //"""
        //    // 
        //  } catch (err) {
        //    // if scan fails, clean up (delete the image) 
        //    // tar up the json files, and fail the build
        //    sh """
        //      docker rmi ${REPOSITORY}:${TAG}
        //      tar -czf reports.tgz anchore-reports/*.json
        //      archiveArtifacts artifacts: 'reports.tgz', fingerprint: true
        //      exit 1
        //    """
        //    // if we used anchore-cli above, we should probably use the plugin here to archive the evaluation
        //    // and generate the report:
        //    //anchore name: 'anchore_images', forceAnalyze: 'true', engineRetries: '900'
        //    //
        //  } // end try
        //} // end script
      } // end steps
    } // end stage "analyze image 1 with anchore plugin"        
    
    stage('Clean up') {
      // if we succuessfully evaluated the image with a PASS than we don't need the $BUILD_ID tag anymore
      steps {
        // if we want to promote the image, this would be a good spot to do it.
        //
        // don't need the image anymore so let's rm it
        //
        // also let's tar up the generated json and archive it.
        sh 'docker image rm ${REPOSITORY}:${TAG}'
        //
        // if we used anchore-cli above, we should probably use the plugin here to archive the evaluation
        // and generate the report:
        //anchore name: 'anchore_images', forceAnalyze: 'true', engineRetries: '900'        
      } // end steps
    } // end stage "clean up"
    
  } // end stages
  
} // end pipeline 
