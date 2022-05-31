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
//Check the 


pipeline{
    agent any
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    // tools{
    //     gradle 'Gradle-7.4.2'
    // }
    stages{
    //     stage('Checkout') {
    //         steps {
    //            echo 'success'
    //         }
    //     }
    //     stage('Build') {
    //         steps {
    //             sh 'gradle clean build'
    //         }
    //         }
    //     stage('Quality Check Analysis') {
    //         steps {
    //             script {
    //                 withSonarQubeEnv(credentialsId: 'sonar_token_2') {
    //                     sh 'gradle sonarqube'
    //             }
    //             timeout (time: 1, unit: 'HOURS') {
    //                 def qg = waitForQualityGate()
    //                 if (qg.status !='OK') {
    //                     error "Pipeline aborted due to quality gate failure: ${qg.status}"
    //                 }
    //             }
    //         }
    //     }
    // }

        stage("sonar quality check"){
            agent {
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar_token_2') {
                            // sh 'chmod +x gradlew'
                            // sh './gradlew sonarqube'
                            sh 'gradle sonarqube'
                    }

                    timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
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
                        docker build -t 34.125.26.178:8083/java-app:${VERSION} .
                        docker login 34.125.26.178:8083 -u admin -p $nexus_pass
                        docker push 34.125.26.178:8083/java-app:${VERSION}
                        docker rmi 34.125.26.178:8083/java-app:${VERSION}
                    '''
                    }
                }
            }
        }


        // stage ('identify misconfigurations using Datree in Helm Chart'){
        //     steps{
        //         script{
        //             // sh 'helm plugin install https://github.com/datreeio/helm-datree'
        //             // sh 'helm plugin update datree'
        //             dir('kubernetes/') {
        //                 withEnv(['DATREE_TOKEN=033c377d-8b0b-493d-81b1-07b4bfe1f613']) {
        //                     sh 'helm datree test myapp/ --no-record'
        //                 }
        //              }
        //         }
        //     }
        // }

                stage ('Pushing the Helm Charts to Nexus'){
            steps{
                script{
                    dir('kubernetes/') {
                        withCredentials([string(credentialsId: 'admin', variable: 'nexus_pass')]) {
                        sh '''
                            helmversion=$( helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                            tar -czvf myapp-${helmversion}.tgz myapp/
                            curl -u admin:$nexus_pass 34.125.26.178:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v
                        '''
                        }
                    }
                }
            }
        }
        // stage('manual approval'){
        //     steps{
        //         script{
        //             timeout(10) {
        //                 mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> Go to build url and approve the deployment request <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "pbride.tech2001@gmail.com";  
        //                 input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
        //             }
        //         }
        //     }
        // }
        stage('Deploying application on k8s cluster') {
            steps {
                script {
                    withCredentials([kubeconfigFile(credentialsId: 'kubernetes', variable: 'KUBECONFIG')]) {
                        // sh 'kubectl get nodes'
                        dir('kubernetes/') {
                        sh 'helm upgrade --install --set image.repository="34.125.26.178:8083/java-app" --set image.tag="${VERSION}" myjavaapp myapp/ '
                        }
                    }
                }
            }
        }
        stage('verifying app deployment'){
            steps{
                script{
                     withCredentials([kubeconfigFile(credentialsId: 'kubernetes', variable: 'KUBECONFIG')]) {
                         sh 'kubectl run curl --image=curlimages/curl -i --rm --restart=Never -- curl myjavaapp-myapp:8080'

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

