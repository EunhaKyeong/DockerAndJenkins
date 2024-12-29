pipeline {
//     agent {
//         docker { image 'android-docker:latest' }
//     }

    agent any

    environment {
        GIT_TAG = ''
        BUILD_TYPE = ''
    }

    stages {
        stage('Get git user info') {
            steps {
                script {
                    // Git 사용자 정보 확인
                    def gitUserName = sh(script: 'git config --global user.name || echo "No Git Username Configured"', returnStdout: true).trim()
                    def gitUserEmail = sh(script: 'git config --global user.email || echo "No Git Email Configured"', returnStdout: true).trim()

                    // Git 사용자 정보 출력
                    echo "Git User Name: ${gitUserName}"
                    echo "Git User Email: ${gitUserEmail}"
                }
            }
        }
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
                    withCredentials([file(credentialsId: 'SECRETFILE', variable: 'LOCAL_PROPERTIES_FILE')]) {
                        sh "cp $LOCAL_PROPERTIES_FILE /Users/ehkyeong/.jenkins/workspace/Docker-Example/local.properties"
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