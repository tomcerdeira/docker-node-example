pipeline {
    agent { dockerfile true }

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
        stage('Run') {
             input {
                message "Deploy to production?"
                submitter "santi,tom"
            }
            steps {
                // unstash 'compiled-results'
                sh 'docker run --rm --name docker-node-example-container --publish 9000:9000 --volume $(pwd):/usr/src/app docker-node-example-image'
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