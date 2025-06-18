    pipeline {
        agent any

        stages {
            stage('Prepare Environment') {
                steps {
                    script {
                        if (env.BRANCH_NAME == 'main') {
                            env.APP_PORT = '3000'
                            env.DOCKER_IMAGE_NAME = 'nodemain:v1.0'
                            env.LOGO_FILE_PATH = 'src/logo-main.svg'
                        } else if (env.BRANCH_NAME == 'dev') {
                            env.APP_PORT = '3001'
                            env.DOCKER_IMAGE_NAME = 'nodedev:v1.0'
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

            stage('Build & Test Docker Image') { // Artık tek adımda
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
                cleanWs()
            }
        }
    }
