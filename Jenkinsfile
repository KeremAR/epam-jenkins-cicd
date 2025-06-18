pipeline {
    agent any

    tools {
        nodejs 'Node 7.8.0'
    }

    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        echo "Setting up for main branch"
                        env.APP_PORT = '3000'
                        env.DOCKER_IMAGE_NAME = 'nodemain:v1.0'
                        env.LOGO_FILE_PATH = 'src/logo-main.svg'
                    } else if (env.BRANCH_NAME == 'dev') {
                        echo "Setting up for dev branch"
                        env.APP_PORT = '3001'
                        env.DOCKER_IMAGE_NAME = 'nodedev:v1.0'
                        env.LOGO_FILE_PATH = 'src/logo-dev.svg'
                    } else {
                        echo "Branch is not main or dev, using default settings."
                        env.APP_PORT = '8000'
                        env.DOCKER_IMAGE_NAME = "node-app:${env.BRANCH_NAME}"
                        env.LOGO_FILE_PATH = 'src/logo.svg'
                    }
                    echo "Port: ${env.APP_PORT}"
                    echo "Docker Image: ${env.DOCKER_IMAGE_NAME}"
                    echo "Logo file: ${env.LOGO_FILE_PATH}"
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Change Logo') {
            steps {
                sh "cp -f ${env.LOGO_FILE_PATH} src/logo.svg"
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test Application') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${env.DOCKER_IMAGE_NAME} ."
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def containerName = "app-${env.BRANCH_NAME}"
                    sh """
                        if [ \$(docker ps -a -q -f name=${containerName}) ]; then
                            echo "Stopping and removing existing container: ${containerName}"
                            docker stop ${containerName}
                            docker rm ${containerName}
                        fi
                    """
                    echo "Deploying container ${containerName} on port ${env.APP_PORT}"
                    sh "docker run -d --name ${containerName} -p ${env.APP_PORT}:3000 ${env.DOCKER_IMAGE_NAME}"
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
