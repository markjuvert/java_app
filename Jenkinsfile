pipeline{
    agent any
    environment{
        VERS v
    }
    tools{
        gradle 'gradle'
    }
    stages{
        stage('SCM Checkout'){
            agent {
                docker {dvf
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
                    withSonarQubeEnv(credentialsId: 'sonar2token') {
                        sh 'chmod +x gradlew'
                        sh './gradlew sonarqube'
                }
                    timeout (2) {
                        //timeout (time: 1, unit: 'HOURS') {
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
