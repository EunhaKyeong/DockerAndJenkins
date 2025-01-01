pipeline {
    agent {
        docker { image 'project-docker:latest' }
    }

    environment {
        GIT_TAG = ''
        BUILD_TYPE = ''
    }

    stages {
        stage('Get git tag') {
            steps {
                script {
                    GIT_TAG = sh(script: 'git describe --tags --exact-match', returnStdout: true).trim()

                    echo "GIT_TAG: ${GIT_TAG}"
                }
            }
        }
    }

    stage('Copy files') {
        steps {
            script {
                withCredentials([file(credentialsId: 'local-properties', variable: 'LOCAL_PROPERTIES_FILE')]) {
                    sh "cp $LOCAL_PROPERTIES_FILE /var/jenkins_home/workspace/dind-example/local.properties"
                }
            }
        }
    }

    post {
        failure {
            echo "빌드 실패"
        }
    }
}