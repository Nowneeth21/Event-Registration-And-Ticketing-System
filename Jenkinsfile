pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nextix-app'
        DOCKER_TAG = "v${env.BUILD_NUMBER}"
        REGISTRY = "your-dockerhub-username/nextix-app"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('TicketSystem') {
                    script {
                        echo "Building Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker build -t ${REGISTRY}:${DOCKER_TAG} -t ${REGISTRY}:latest ."
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir('TicketSystem') {
                    script {
                        echo "Running Django Checks"
                        sh "docker run --rm ${REGISTRY}:latest python manage.py check"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Requires Jenkins credentials setup for DockerHub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        sh "docker push ${REGISTRY}:${DOCKER_TAG}"
                        sh "docker push ${REGISTRY}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Requires Jenkins credentials setup for Kubeconfig
                    echo "Deploying to Kubernetes Cluster"
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                    sh "kubectl set image deployment/nextix-deployment nextix-app=${REGISTRY}:${DOCKER_TAG}"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline Execution Complete'
            sh 'docker logout'
        }
        success {
            echo 'Build & Deployment Successful!'
        }
        failure {
            echo 'Build Failed. Please check the logs.'
        }
    }
}
