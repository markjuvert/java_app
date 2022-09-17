# java_app
This repo is about deploying an Application using Jenkins CI/CD pipeline.
In this demo, an application source code is used to demonstrate a fully functional Jenkins pipeline with some really cool feautures that are used in production workload such as automating installation and configurations, code analaysis, automatic and manual approval in the pipeline, different APIs just as in a microservice app, the use of different servers for different API permits easy load balancing, scalability, availability and most of all easy troubleshooting.


## Structure of the App.

The application structure consist of a Jenkins server which runs the Jenkins CI/CD pipeline that interacts with other APIs of the pipeline such as a kubernetes cluster, a container image registry, a static code analysis API, a version control management/source control management and many more. 

### Pull the application code from github
The pipeline starts by creating a Jenkins pipeline job using Pipeline script from SCM which pulls the application code and run it via the pipeline.

### Code Analysis
The next stage involves scanning the code to remove errors, misconfigurations and also to make sure we can run the code safely. In this stage, the sonarqube plugin is integrated in Jenkins by configuring an environment variable in the pipeline, and a sonarqube token is generated which jenkins will use to authenticate to sonarqube. Also, a webhook is created between jenkins and sonarqube to allow communication between them.

Sonarqube have many rules such as duplications, vulnerability check, security hotspot, reliability, Maintainability Rating, deprecated, functions check amongst others that can be assigned to a quality gate. Once the scanning is complete, the code can either pass or fail the quality gate check. If the code passes the quality gate check, it can move to the next steps but if it fails, it will abort the next steps will not be performed. 

![Sonar Quality Gate](sonarqualitygate.png)