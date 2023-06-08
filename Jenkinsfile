pipeline {
    agent { dockerfile true }

    environment {
        SLACK_CHANNEL     = '#random'
        SLACK_CREDENTIALS = '3030150e-a11f-4c22-b001-0435721f1249' // Esto es el id de la credencial que esta guardada en jenkins
    }

    parameters {
        choice(
            choices: ['development', 'production'],
            description: 'Select the environment for deployment',
            name: 'DEPLOY_ENVIRONMENT'
        )
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker build --tag docker-node-example-image .'
            }
        }
        stage('Test') {
            steps {
                sh 'docker run --rm docker-node-example-image npm test'
            }
        }
        stage('Deploy - Development') {
            when {
                expression { params.DEPLOY_ENVIRONMENT == 'development' }
            }
            steps {
                script {
                    deploy('docker-node-example-image',"9005")
                }
            }
        }

        stage('Deploy - Production') {
            when {
                expression { params.DEPLOY_ENVIRONMENT == 'production' }
            }
            steps {
                input message:"Deploy to production?",submitter: "tom" 
                script {
                    // Save the last running version of the container
                    sh "docker tag docker-node-example-image:latest docker-node-example-image:previous"
                    deploy('docker-node-example-image', "9000")
                }
            }
        }
    }
    
    post {
        success {
            script {
                slackSend color: 'good',
                          message: "Build <${BUILD_URL}|#${BUILD_NUMBER}> from ${JOB_NAME} succeded! ${"<https://github.com/tomcerdeira/docker-node-example |GitHub>"}",
                          channel: SLACK_CHANNEL,
                          tokenCredentialId: SLACK_CREDENTIALS 
            }
        }
        failure {
            script {
                slackSend color: 'red',
                          message: "Build <${BUILD_URL}|#${BUILD_NUMBER}> from ${JOB_NAME} failed :( CHECK LOGS IN BUILD: ${"<https://github.com/tomcerdeira/docker-node-example |GitHub>"}",
                          channel: SLACK_CHANNEL,
                          tokenCredentialId: SLACK_CREDENTIALS
                if(params.DEPLOY_ENVIRONMENT == 'production') {
                    rollback('docker-node-example-image:previous',9000)
                }else{
                    rollback('docker-node-example-image:previous',9005)
                }
            }
        }
    }
}

def deploy(String image = 'docker-node-example-image', String port = 9000) {
    // Check if a container is already running on the specified port
    def existingContainerId = sh(returnStdout: true, script: "docker ps -q -f 'expose=${port}/tcp'").trim()
    if (existingContainerId) {
        // Stop the existing container
        sh "docker stop ${existingContainerId}"
        sh "docker rm ${existingContainerId}"
    }

    docker.withRegistry('') {
        def dockerImage = docker.image(image)
        dockerImage.run("-p ${port}:${port} -e DEPLOY_ENVIRONMENT=${params.DEPLOY_ENVIRONMENT}")
    }
}

def rollback(String image = 'docker-node-example-image:previous', int port = 9000){
    // Check if the rollback container is running successfully
    def existingContainerId = sh(returnStdout: true, script: "docker ps -q -f 'expose=${port}/tcp'").trim()
    if(!existingContainerId){                                                                  
        def rollbackContainer = docker.image(image).run("-p ${port}:${port}")
        if (rollbackContainer) {
            echo "Rollback succeeded. Previous container is running."
        } else {
            echo "Rollback failed. Please investigate and manually revert the deployment."
        }
    }else{
        echo "No action needed, server is already running."
    }     
}
