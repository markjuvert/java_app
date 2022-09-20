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
                    withSonarQubeEnv(credentialsId: 'sonar2token') {
                        //sonar2token
                        //sh 'gradle sonarqube'
                        sh 'chmod +x gradlew'
                        sh './gradlew sonarqube'
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
    stage("Build docker image and push to a repo"){
        steps{
            script{
                sh '''
                withCredentials([string(credentialsId: 'admin', variable: 'docker_pw')]) {
}               docker login -u admin -p $docker_pw 54.162.183.108:8083
                docker build -t 54.162.183.108:8083/webapp:${VERSION} .
                docker rmi 54.162.183.108:8083/webapp:${VERSION}
                '''
            }
        }
    }
    }

}
