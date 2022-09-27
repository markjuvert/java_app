pipeline{
    agent any
    environment {
        VERSION = "${env.BUILD_ID}"
        //DOCKERHUB_CREDENTIALS = "credentials('juvertm')"
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
        //Pushing image to a Private repo such as Nexus
        stage("Build docker image and push to a repo"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pw', variable: 'docker_pw')]) {
                        echo 'Starting Docker'
                        sh '''
                        docker login 54.234.43.254:8083 -u admin -p $docker_pw
                        '''
                        //docker build -t 54.234.43.254:8083/webapp:${VERSION} .
                        //docker push 54.234.43.254:8083/webapp:${VERSION}
                        //docker rmi 54.234.43.254:8083/webapp:${VERSION}
                    }
                }
            }
        }

        //Build a docker image
        // stage("Build docker image"){
        //     steps {
        //         sh 'docker build -t juvertm/webapp:$BUILD_NUMBER .'
        //     }

        // }
        // Push Image to Docker hub
        // stage('Push image to Docker Hub') {
        //     steps {
        // withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
        //   sh  'docker push juvertm/webapp:$BUILD_NUMBER'
        //         }
        //     }
        // }


        // Identify Misconfigurations using Datree Helm 
        stage ('Identify misconfigurations using Datree in Helm Chart'){
                    steps{
                        script{
                            dir('kubernetes/') {
                                withEnv(['DATREE_TOKEN=033c377d-8b0b-493d-81b1-07b4bfe1f613']) {
                                //sh 'helm plugin install https://github.com/datreeio/helm-datree'
                                //sh 'helm plugin update datree'
                                //sh 'helm datree version'
                                sh 'helm datree test myapp/'
                                }
                            }
                        }
                    }
                }
        // Push Helm charts to Nexus Repository
        stage ('Pushing the Helm Charts to Nexus'){
            steps{
                script{
                    dir('kubernetes/') {
                        withCredentials([string(credentialsId: 'docker_pw', variable: 'docker_pw')]) {
                        sh '''
                            helmversion=$( helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                            tar -czvf myapp-${helmversion}.tgz myapp/
                            curl -u admin:$docker_pw 54.234.43.254:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v
                        '''
                        }
                    }
                }
            }
        }

        // manual Approval before Deploying to K8S Clustter
        stage('manual approval'){
            steps{
                script{
                    timeout(10) {
                        mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> Go to build url and approve the deployment request <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "pbride.tech2001@gmail.com";
                        input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                    }
                }
            }
        }

        // stage('Deploying application to k8s cluster') {
        //     steps {
        //         script {
        //              withKubeConfig([credentialsId: 'kubernetes-config']) {
        //                 sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"'
        //                 sh 'chmod u+x ./kubectl'
        //                 sh './kubectl get nodes'
        //                 dir('kubernetes/') {
        //                 sh 'helm upgrade --install --set image.repository="54.234.43.254:8083/webapp" --set image.tag="${VERSION}" myjavaapp myapp/ '
        //                 }
        //               }
        //             }
        //         }
        //     }


        // verifying if deployment is successful
        stage('verifying application deployment'){
            steps{
                script{
                     withKubeConfig([credentialsId: 'kubernetes-config']) {
                         sh 'kubectl run curl --image=curlimages/curl -i --rm --restart=Never -- curl myjavaapp-myapp:8080'

                     }
                }
            }
        }
}

    // post {
    //         always {
    //             mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "pbride.tech2001@gmail.com";
    //         }
    //     }

}
