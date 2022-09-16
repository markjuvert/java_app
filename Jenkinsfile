pipeline{
    agent any
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    tools{
        gradle 'gradle'
    }
    stages{
        stage('SCM Checkout'){
            agent {
                docker {
                    image 'openjdk:11'
                }
            }
            steps {
               echo 'Code pull from github successful'
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
                    withSonarQubeEnv(credentialsId: 'sonar-token') {
                        sh 'chmod +x gradlew'
                        sh 'gradle sonarqube'
                }
                    timeout (2) {
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
