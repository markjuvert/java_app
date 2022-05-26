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
    tools{
        gradle 'Gradle-7.4.2'
    }
    stages{
        stage('Checkout') {
//            agent { docker 'gradle:6-jdk8' }
            steps {
               echo 'success'
            }
        }
        stage('Using Docker') {
            agent {
                docker {
                    image 'openjdk:11'
                }
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
}
}