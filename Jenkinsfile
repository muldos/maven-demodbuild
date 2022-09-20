pipeline {
    agent any
    stages {
        stage('Build & Unit tests') {
            agent { 
                docker { 
                        image 'maven:3.8-jdk-11'
                        args '-v $HOME/.m2:/root/.m2'
                        reuseNode true
                } 
            }
            steps {
                //let's start with a fresh state
                sh 'rm -rf ./petclinic_src ./petclinic.jar'
                dir('petclinic_src') {
                    git branch: 'main', url: 'https://github.com/spring-projects/spring-petclinic.git'
                    sh 'mvn -B -Dcheckstyle.skip clean package -X'
                    sh 'ls -al /root/.m2'
                }
                sh 'mv petclinic_src/target/spring-petclinic-*.jar ./petclinic.jar'
            }
        }
       stage('Deploy Maven artifact') {
            steps {
                sh 'echo "todo"'
       } 
       stage('Deploy Docker Image') {
            environment { 
                ARTIFACTORY_CREDENTIALS=credentials('artifactorySaas')
            }
            steps {
                sh 'echo $ARTIFACTORY_CREDENTIALS_PSW | docker login $artifactoryHost -u $ARTIFACTORY_CREDENTIALS_USR --password-stdin'
                
                /**
                * Plain old shell docker push
                */
                //sh "docker build -t ${params.artifactoryHost}/${params.artifactoryDockerRegistry}/petclinic:corretto11-latest ."
                //sh "docker push ${params.artifactoryHost}/${params.artifactoryDockerRegistry}/petclinic:corretto11-latest"
                /**
                * Docker push using dedicated functions from the Jenkin's Artifactory plugin.
                */
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
