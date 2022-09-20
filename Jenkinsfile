pipeline {
    agent any
    stages {
        stage('Build') {
            agent { docker { 
                        image 'maven:3.8-jdk-11'
                        reuseNode true
                    } 
            }
            steps {
                //cleaning
                sh 'rm -rf ./petclinic_src ./petclinic.jar'
                dir('petclinic_src') {
                    git branch: 'main', url: 'https://github.com/spring-projects/spring-petclinic.git'
                    sh 'mvn -B -Dcheckstyle.skip clean package -U'
                }
                sh 'mv petclinic_src/target/spring-petclinic-*.jar ./petclinic.jar'
            }
        }
       stage('Deploy') {
            environment { 
                ARTIFACTORY_CREDENTIALS=credentials('artifactorySaas')
            }
            steps {
                sh 'echo $ARTIFACTORY_CREDENTIALS_PSW | docker login drobin.jfrog.io -u $ARTIFACTORY_CREDENTIALS_USR --password-stdin'
                sh 'docker build -t petclinic:latest .'
                sh 'docker tag petclinic:latest drobin.jfrog.io/default-docker-virtual/petclinic:latest'
                sh 'docker push drobin.jfrog.io/default-docker-virtual/petclinic:latest'
 
            }
        }
    }
}
