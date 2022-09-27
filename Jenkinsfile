pipeline {
    agent any
    stages {
        stage ('Init') {
             environment { 
                ARTIFACTORY_CREDENTIALS=credentials('artifactoryManaged')
            }
            steps {
                 sh 'echo $ARTIFACTORY_CREDENTIALS_PSW | docker login $artifactoryHost -u $ARTIFACTORY_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Build & Unit tests') {
            environment { 
                ARTIFACTORY_CREDENTIALS=credentials('artifactoryManaged')
            }
            agent { 
                docker { 
                        image params.artifactoryHost + '/' + params.artifactoryDockerRegistry + '/maven:3.8-jdk-11'
                        args '-u root --privileged -v $HOME/.m2:/root/.m2'
                        reuseNode true
                } 
            }
            steps {
                //let's start with a fresh state
                sh 'rm -rf ./petclinic_src ./petclinic.jar'
                dir('petclinic_src') {
                    git branch: 'main', url: 'https://github.com/spring-projects/spring-petclinic.git'
                    sh 'mvn -s ../ci-settings.xml -B -Dcheckstyle.skip clean package'
                    sh 'mvn -s ../ci-settings.xml -B -Dcheckstyle.skip deploy'
                }
                sh 'mv petclinic_src/target/spring-petclinic-*.jar ./petclinic.jar'
            }
        }
       stage('Deploy Docker Image') {
            environment { 
                ARTIFACTORY_CREDENTIALS=credentials('artifactoryManaged')
            }
            steps {
                //sh 'echo $ARTIFACTORY_CREDENTIALS_PSW | docker login $artifactoryHost -u $ARTIFACTORY_CREDENTIALS_USR --password-stdin'
                sh 'docker build -t $artifactoryHost/$artifactoryDockerRegistry/petclinic:$BUILD_NUMBER .'
                sh 'docker tag $artifactoryHost/$artifactoryDockerRegistry/petclinic:$BUILD_NUMBER  $artifactoryHost/$artifactoryDockerRegistry/petclinic:corretto11-latest'

                /**
                * Plain old shell docker push
                */
                //sh "docker push ${params.artifactoryHost}/${params.artifactoryDockerRegistry}/petclinic:corretto11-latest"
                /**
                * Docker push using dedicated functions from the Jenkin's Artifactory plugin.
                */
                rtBuildInfo(
                    captureEnv: true
                )
                rtDockerPush(
                    serverId: 'selfHosted',
                    image: params.artifactoryHost + '/' + params.artifactoryDockerRegistry + '/petclinic:' + env.BUILD_NUMBER,
                    targetRepo: params.artifactoryDockerRegistry,
                    // Attach custom properties to the published artifacts:
                    properties: 'project-name=petclinic;status=stable',
                )
                rtDockerPush(
                    serverId: 'selfHosted',
                    image: params.artifactoryHost + '/' + params.artifactoryDockerRegistry + '/petclinic:corretto11-latest',
                    targetRepo: params.artifactoryDockerRegistry,
                    // Attach custom properties to the published artifacts:
                    properties: 'project-name=petclinic;status=stable',
                )
                rtPublishBuildInfo (
                    serverId: 'selfHosted'
                )
            }
        }
    }
}
