# Deployed the application by using jenkins and Github by automating the build, test and deployment of the application. Used the docker to create image and run image to create container.

The project aims to automate the building, testing, and deployment process of a web application using Jenkins and GitHub. The Jenkins pipeline will be triggered automatically by GitHub webhook integration when changes are made to the code repository. 
The pipeline will include stages such as building, testing, and deploying the application, with notifications and alerts for failed builds or deployments.

Deployed the application using Jenkins declarative pipeline. Pipeline consists of  5 stages. Configured webhook on the github to automate the CI/CD.
When the code is pushed on github, github plugin in jenkins will check if the particular job has that git repository and has the GITScm polling. if yes then that job will start executing.



pipeline {
    
    agent any
       stages {
           
           stage("Pulling code from github") {
             steps {
                 git url: 'https://github.com/422divya/todp-app-code-cloned.git', branch: 'develop'
                 
             }
           
       }
       
           stage("Testing code") {
             steps {
                 
               
                echo "Testing successfull"
             }    
    
           }
    
           stage("Building the code using docker") {
               steps {
                   sh "docker build -t divya422/todo-img ."
                   
               }
               
           }
           
           stage("Pushing the created application image to dockerhub") {
               
               steps {
                   
                   withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'dockeruser', passwordVariable: 'dockerpassword')])
                   {
                       sh "docker login -u ${env.dockeruser} -p ${env.dockerpassword}"
                       sh "docker push divya422/todo-img"
                   }
                   
               }
           }
           
           
           stage("Deploying the application as container") {
               
               steps {
                  sh "docker-compose up" 
                   
               }
           }
           
   
       }
}
