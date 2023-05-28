pipeline {
    agent any

    environment {
        PROJECT_NAME      = 'docker-node-example'
        GIT_URL           = 'https://github.com/tomcerdeira/docker-node-example'
        SLACK_CHANNEL     = '#random'
        SLACK_CREDENTIALS = '3030150e-a11f-4c22-b001-0435721f1249' // Esto es el id de la credencial que esta guardada en jenkins
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
        stage('Deploy') {
            input {
                message "Deploy to production?"
                submitter "santi,tom"
            }
            steps {
                script {
                    // Save the last running version of the container
                    sh "docker tag docker-node-example-image:latest docker-node-example-image:previous"
                    deploy('docker-node-example-image')
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
                          message: "Build <${BUILD_URL}|#${BUILD_NUMBER}> from ${JOB_NAME} failed :(: ${"<https://github.com/tomcerdeira/docker-node-example |GitHub>"}",
                          channel: SLACK_CHANNEL,
                          tokenCredentialId: SLACK_CREDENTIALS
                
                rollback('docker-node-example-image:previous')
            }
        }
    }
}

def deploy(String image = 'docker-node-example-image'){
    // Check if a container is already running on the specified port
    def existingContainerId = sh(returnStdout: true, script: "docker ps -q -f 'expose=9000/tcp'").trim()
    if (existingContainerId) {
        // Stop the existing container
        sh "docker stop ${existingContainerId}"
        sh "docker rm ${existingContainerId}"
    }

    docker.withRegistry('') {
    def dockerImage = docker.image(image)
    dockerImage.run('-p 9000:9000')
    }
}

def rollback(String image = 'docker-node-example-image:previous'){
    // Check if the rollback container is running successfully
    def existingContainerId = sh(returnStdout: true, script: "docker ps -q -f 'expose=9000/tcp'").trim()
    if(!existingContainerId){                                                                  
        def rollbackContainer = docker.image(image).run('-p 9000:9000')            
        if (rollbackContainer) {
            echo "Rollback succeeded. Previous container is running."
        } else {
            echo "Rollback failed. Please investigate and manually revert the deployment."
        }
    }else{
        echo "No action needed, server is already running."
    }     
}
