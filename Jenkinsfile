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
                //let's start with a fresh state
                sh 'rm -rf ./petclinic_src ./petclinic.jar'
                dir('petclinic_src') {
                    git branch: 'main', url: 'https://github.com/spring-projects/spring-petclinic.git'
                    sh 'mvn -B -Dcheckstyle.skip clean package -U'
                    sh 'ls -al'
                }
                sh 'mv petclinic_src/target/spring-petclinic-*.jar ./petclinic.jar'
            }
        }
       stage('Deploy') {
            environment { 
                ARTIFACTORY_CREDENTIALS=credentials('artifactorySaas')
            }
            steps {
                sh "echo $ARTIFACTORY_CREDENTIALS_PSW | docker login ${params.artifactoryHost} -u $ARTIFACTORY_CREDENTIALS_USR --password-stdin"
                sh "docker build -t ${params.artifactoryHost}/${params.artifactoryDockerRegistry}/petclinic:corretto11-latest ."
                //sh "docker push ${params.artifactoryHost}/${params.artifactoryDockerRegistry}/petclinic:corretto11-latest"
                rtDockerPush(
                    serverId: 'freeSaasTier',
                    image: params.artifactoryHost + '/' + params.artifactoryDockerRegistry + '/petclinic:corretto11-latest',
                    targetRepo: 'default-docker-local',
                    // Attach custom properties to the published artifacts:
                    properties: 'project-name=petclinic;status=stable',
                )

                rtPublishBuildInfo (
                    serverId: 'freeSaasTier'
                )
            }
        }
    }
}
