pipeline {
    environment {
        IMAGEN = "larapruna/django_python"
        USUARIO = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("Instalación y testeo") {
            agent {
                docker { image "python:3"
                args '-u root:root'
                }
            }
            stages {
                stage('Clone') {
                    steps {
                        git 'https://github.com/LaraPruna/django_tutorial'
                    }
                }
                stage('Install') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test')
                {
                    steps {
                        sh 'python3 manage.py test'
                    }
                }

            }
        }
        stage("Contrucción de la imagen") {
            agent any
            stages {
                stage('CloneHost') {
                    steps {
                        git 'https://github.com/LaraPruna/docker_django'
                    }
                }
                stage('BuildImage') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:latest"
                        }
                    }
                }
                stage('UploadImage') {
                    steps {
                        script {
                            docker.withRegistry( '', USUARIO ) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('RemoveImage') {
                    steps {
                        sh "docker rmi $IMAGEN:latest"
                    }
                }
		stage ('Despliegue') {
                    steps{
			sshagent(credentials : SSH) {
                            sh 'scp -o StrictHostKeyChecking=no docker-compose.yaml root@serenity.sysraider.es:'
                            sh 'ssh -o StrictHostKeyChecking=no root@serenity.sysraider.es docker-compose up -d --force-recreate'
			}
                    }
		}
            }
        }           
    }
    post {
        always {
            mail to: 'larapruter@gmail.com',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}
