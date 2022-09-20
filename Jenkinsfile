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
            steps {
		        sh 'ls -al'
                sh 'docker build -t muldos/petclinic:latest .'
                sh 'docker tag muldos/petclinic:latest drobin.jfrog.io/default-docker-local/petclinic:latest'
 
            }
        }
    }
}
