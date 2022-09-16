pipeline{
    agent any
    tools{
        gradle 'Gradle-7.4.2'
    }
    stages{
        stage("Sonar Quality Check"){
            agent {
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-token') {
                        sh 'chmod +x gradlew'
                        sh 'gradle sonarqube'
                        //sh './gradlew sonarqube'
}
                }
            }
         }
    }
    post{
        always{
            echo "SUCCESS"
        }
    }
}