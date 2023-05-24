pipeline {
    agent any

    environment {
        PROJECT           = 'tpe-redes'
        SLACK_CHANNEL     = '#random'
        SLACK_CREDENTIALS = '3030150e-a11f-4c22-b001-0435721f1249'
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
        stage('Deploy'){
            input {
                message "Deploy to production?"
                submitter "santi,tom"
            }
            steps{
                script {
                    def existingContainerId = sh(returnStdout: true, script: "docker ps -q -f 'expose=9000/tcp'").trim()

                    if (existingContainerId) {
                        echo existingContainerId
                        // Stop the existing container
                        sh "docker stop ${existingContainerId}"
                        sh "docker rm ${existingContainerId}"
                    }
                    docker.withRegistry('') {
                        def dockerImage = docker.image('docker-node-example-image')
                        def container = dockerImage.run('-p 9000:9000')
                    }
                }
            }
        }
    }
    
    post {
        success {
            script {
                slackSend color: 'good',
                          message: "Build <${BUILD_NUMBER}> from ${JOB_NAME} succeded! Link to repo: ${"<https://github.com/santigarciam/tpe-redes |GitHub>"}",
                          channel: SLACK_CHANNEL,
                          tokenCredentialId: SLACK_CREDENTIALS // OBS: Esto es el id de la credencial que tengo guardada en jenkins,
                                                                                    //       NO es la cred en plano
            }
        }
        failure {
            script {
                slackSend color: 'red',
                          message: "Build <${BUILD_NUMBER}> from ${JOB_NAME} fail :( Link to repo: ${"<https://github.com/santigarciam/tpe-redes |GitHub>"}",
                          channel: SLACK_CHANNEL,
                          tokenCredentialId: SLACK_CREDENTIALS // OBS: Esto es el id de la credencial que tengo guardada en jenkins,
                                                                                    //       NO es la cred en plano
            }
        }
    }
}
