pipeline{
    agent any
    environment {
        //VERSION = "${env.BUILD_ID}"
        DOCKERHUB_CREDENTIALS = "credentials('juvertm')"
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
        // Pushing image to a Private repo such as Nexus
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

        //G S
        // stage("Build docker image"){
        //     steps {
        //         sh 'docker build -t juvertm/webapp:$BUILD_NUMBER .'
        //     }

        // }
        // stage('Push image to Docker Hub') {
        //     steps {
        // withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
        //   sh  'docker push juvertm/webapp:$BUILD_NUMBER'
        //         }
        //     }
        // }
    }
}
