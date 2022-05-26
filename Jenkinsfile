// pipeline{
//     agent any
//     stages{
//         stage("Sonar quality check"){
//             agent {
//                 docker {
//                     image 'openjdk:11'
//                 }
//             }
//             steps{
//                 script {
//                     withSonarQubeEnv(credentialsId: 'sonar_token') {
//                         sh 'gradle sonarqube'
//                 }
//                 timeout (time: 1, unit: 'HOURS') {
//                     def qg = waitForQualityGate()
//                     if (qg.status !='OK') {
//                         error "Pipeline aborted due to quality gate failure: ${qg.status}"
//                     }
//                 }
//             }
//         }
//     }
// }
// }


pipeline{
    agent any
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    tools{
        gradle 'Gradle-7.4.2'
    }
    stages{
        stage('Checkout') {
            steps {
               echo 'success'
            }
        }
        stage('Build') {
            steps {
                sh 'gradle clean build'
            }
            }
        stage('Quality Check Analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'sonar_token') {
                        sh 'gradle sonarqube'
                }
                timeout (time: 1, unit: 'HOURS') {
                    def qg = waitForQualityGate()
                    if (qg.status !='OK') {
                        error "Pipeline aborted due to quality gate failure: ${qg.status}"
                    }
                }
            }
        }
    }
        stage ('docker build & docker push'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass-nexus_passwd', variable: 'docker_pass_2_access_nexus')]) {
                    sh '''
                        docker build -t 34.125.67.248:8083/java-app:${VERSION} .
                        docker login -u admin -p docker_pass-nexus_passwd 34.125.67.248:8083
                        docker push 34.125.67.248:8083/java-app:${VERSION}
                        docker rmi 34.125.67.248:8083/java-app:${VERSION}
                    '''
}

                }
            }
        }
}
}

