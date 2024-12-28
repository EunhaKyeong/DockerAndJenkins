pipeline {
    agent {
        docker { image 'android-docker:latest' }
    }

    environment {
        GIT_TAG = ''
        BUILD_TYPE = ''
    }

    stages {
//         stage('Get git tag') {
//             steps {
//                 script {
//                     sh 'git config --global --add safe.directory /Users/ehkyeong/.jenkins/workspace/Docker-Example'
//
//                     GIT_TAG = sh(script: 'git describe --tags --exact-match', returnStdout: true).trim()
//
//                     echo "GIT_TAG: ${GIT_TAG}"
//                 }
//             }
//         }

//         stage('Check build type') {
//             steps {
//                 script {
//                     if (GIT_TAG.startsWith("dev-v")) {
//                         BUILD_TYPE = "dev"
//                     } else if (GIT_TAG.startsWith("qa-v")) {
//                         BUILD_TYPE = "qa"
//                     } else if (GIT_TAG.startsWith("prod-v")) {
//                         BUILD_TYPE = "prod"
//                     } else {
//                         error("Invalid tag: ${GIT_TAG}")
//                     }
//
//                     echo "BUILD_TYPE: ${BUILD_TYPE}"
//                 }
//             }
//         }

        stage('Copy files') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'Local-Properties', variable: 'LOCAL_PROPERTIES_FILE')]) {
                        sh "cp $SECRET_FILE /Users/ehkyeong/.jenkins/workspace/Docker-Example"
                    }
                }
//                 sh 'cp -R /opt/aos_evpedia/keystore /var/lib/jenkins/workspace/aos_evpedia/app'
//                 sh 'cp -R /opt/aos_evpedia/local.properties /var/lib/jenkins/workspace/aos_evpedia'
//                 sh 'cp -R /opt/aos_evpedia/google-services.json /var/lib/jenkins/workspace/aos_evpedia/app'
            }
        }

        stage('Clean') {
            steps {
                sh './gradlew clean'
            }
        }

        stage('Test') {
            steps {
                sh './gradlew test'
            }
        }

        stage('Build and deploy') {
            steps {
                script {
                     sh "./gradlew assembleDebug"
                }
            }
        }

//         stage('Build and deploy') {
//             steps {
//                 script {
//                     if (BUILD_TYPE == 'dev') {
//                         sh "./gradlew assembleDebug"
//                     } else if (BUILD_TYPE == 'qa') {
//
//                     } else if (BUILD_TYPE == 'prod') {
//                         sh "./gradlew bundleProdRelease appDistributionUploadProdRelease"
//                     } else {
//                         error("Invalid BUILD_TYPE: ${BUILD_TYPE}")
//                     }
//                 }
//             }
//         }
    }

    post {
        failure {
            echo "빌드 실패"
        }
    }
}