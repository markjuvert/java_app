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
                    withCredentials([string(credentialsId: 'admin', variable: 'nexus_pass')]) {
                    sh '''
                        docker build -t 34.125.67.248:8083/java-app:${VERSION} .
                        docker login -u admin -p $nexus_pass 34.125.67.248:8083
                        docker push 34.125.67.248:8083/java-app:${VERSION}
                        docker rmi 34.125.67.248:8083/java-app:${VERSION}
                    '''
}
                }
            }
        }
        // stage('indentifying misconfigs using datree'){
        //     steps{
        //         script{
        //                 withEnv(['DATREE_TOKEN=9de05cb3-14d1-4ed3-b672-c80b2478a7e5']) {
        //                       sh 'datree test myapp/'
        //                 }

        //         }
        //     }
        // }
        stage ('identify misconfigurations using Datree in Helm Chart'){
            steps{
                script{
                    dir('kubernetes/') {
                        sh '''
                        helm datree test kubernetes/myapp/ --no-record
                        '''
                    }
                }
            }
        }
    }
        post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "pbride.tech2001@gmail.com";
		}
	}
//   helm plugin install https://github.com/datreeio/helm-datree
//                        helm plugin update datree
}

