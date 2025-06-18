pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('dockerhub-credentials') 
    }

    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    def dockerhubUser = "keremar" 

                    if (env.BRANCH_NAME == 'main') {
                        env.APP_PORT = '3000'
                        env.DOCKER_IMAGE_NAME = "${dockerhubUser}/cicd-app:main-v1.0"
                        env.LOGO_FILE_PATH = 'src/logo-main.svg'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.APP_PORT = '3001'
                        env.DOCKER_IMAGE_NAME = "${dockerhubUser}/cicd-app:dev-v1.0"
                        env.LOGO_FILE_PATH = 'src/logo-dev.svg'
                    }
                }
            }
        }
        
        stage('Change Logo') {
            steps {
                sh "cp -f ${env.LOGO_FILE_PATH} src/logo.svg"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${env.DOCKER_IMAGE_NAME} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                    sh "docker push ${env.DOCKER_IMAGE_NAME}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def containerName = "app-${env.BRANCH_NAME}"
                    sh """
                        if [ \$(docker ps -a -q -f name=${containerName}) ]; then
                            docker stop ${containerName}
                            docker rm ${containerName}
                        fi
                    """
                    sh "docker run -d --name ${containerName} -p ${env.APP_PORT}:3000 ${env.DOCKER_IMAGE_NAME}"
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
    }
}
