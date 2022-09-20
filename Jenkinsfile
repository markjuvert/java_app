pipeline{
    agent any
    environment {
        //VERSION = "${env.BUILD_ID}"
        DOCKERHUB_CREDENTIALS=credentials('juvertm')
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
        // stage("Build docker image and push to a repo"){
        //     steps{
        //         script{
        //             withCredentials([string(credentialsId: 'admin', variable: 'docker_pw')]) {
        //             sh '''
        //             docker build -t 54.166.202.199:8083/webapp:${VERSION} .
        //             docker login 54.166.202.199:8083 -u admin -p $docker_pw
        //             docker push 54.166.202.199:8083/webapp:${VERSION}
        //             docker rmi 54.166.202.199:8083/webapp:${VERSION}
        //             '''
        //             }
        //         }
        //     }
        // }
        stage("Build docker image"){
            steps {
                sh 'docker build -t juvertm/webapp:latest .'
            }

        }
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push') {
            steps {
            sh 'docker push juvertm/webapp:latest'
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }

}
