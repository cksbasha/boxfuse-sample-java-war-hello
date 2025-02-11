
pipeline {

  environment {
    PROJECT = "indigo-history-337312"
    APP_NAME = "hello"
    FE_SVC_NAME = "${APP_NAME}-frontend"
    CLUSTER = "way2die"
    CLUSTER_ZONE = "us-central1-c"
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    JENKINS_CRED = "${PROJECT}"
  }

  agent {
    kubernetes {
      inheritFrom 'sample-app'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
 # serviceAccountName: cd-jenkins
  containers:
  - name: maven-bld
    image: maven:amazoncorretto
    command:
    - cat
    tty: true
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    command:
    - cat
    tty: true
"""
}
  }
  stages {
    stage('codebuild') {
      steps {
        container('maven-bld') {
          sh """
             ls -a && pwd 
             mvn clean install
             cp -r target/* .
          """
        }
      }
    }
    stage('Build and push image with Container Builder') {
      steps {
        container('gcloud') {
          sh "PYTHONUNBUFFERED=1 gcloud builds submit -t ${IMAGE_TAG} ."
        }
      }
    } 
    stage('Deploy Dev') {
      steps {
        container('kubectl') {
          sh "gcloud container clusters get-credentials way2die --zone us-central1-c --project indigo-history-337312"
          sh "kubectl --help "
         
        }
      }
    }
  }
}
