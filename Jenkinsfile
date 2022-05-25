pipeline{
    agent any
    stages{
        stage("Sonar quality check"){
            agent {
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar_token') {
                        sh "chmod +x gradlew"
                        sh "java -version"
                        sh "gradle sonarqube"
                }
            }
        }
    }
}
}