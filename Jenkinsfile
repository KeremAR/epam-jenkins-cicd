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
                    def dockerhubRepo = "epam-jenkins-lab"

                    if (env.BRANCH_NAME == 'main') {
                        env.DOCKER_IMAGE_NAME = "${dockerhubUser}/${dockerhubRepo}:main-v1.0"
                        env.LOGO_FILE_PATH = 'src/logo-main.svg'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.DOCKER_IMAGE_NAME = "${dockerhubUser}/${dockerhubRepo}:dev-v1.0"
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
    }
    
    post {
        success {
            script {
                echo "Build successful. Triggering deployment..."
                if (env.BRANCH_NAME == 'main') {
                    build job: 'Deploy_to_main', wait: false,  parameters: [string(name: 'IMAGE_TO_DEPLOY', value: env.DOCKER_IMAGE_NAME)]
                } else if (env.BRANCH_NAME == 'dev') {
                    build job: 'Deploy_to_dev', wait: false, parameters: [string(name: 'IMAGE_TO_DEPLOY', value: env.DOCKER_IMAGE_NAME)]
                }
            }
        }
        
        always {
            echo "Logging out from Docker Hub..."
            sh 'docker logout'
            cleanWs()
        }
    }
}
