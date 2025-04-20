pipeline {
    agent any

    environment {
        REGISTRY = "registry.gitlab.com/rzktok/api.timsakti.com"
    }

    stages {
        stage('Login to GitLab Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'gitlab-registry', usernameVariable: 'REGISTRY_USER', passwordVariable: 'REGISTRY_PASS')]) {
                        sh "echo $REGISTRY_PASS | docker login -u $REGISTRY_USER --password-stdin $REGISTRY"
                    }
                }
            }
        }

        stage('Extract App Info') {
            steps {
                script {
                    // Ambil versi sekarang dari package.json
                    def APP_VERSION = sh(script: "grep '\"version\"' package.json | head -1 | cut -d '\"' -f4", returnStdout: true).trim()
                    env.APP_VERSION = APP_VERSION

                    // Ambil versi sebelumnya dari commit sebelumnya
                    def PREVIOUS_APP_VERSION = sh(script: "git show HEAD^:package.json | grep '\"version\"' | head -1 | cut -d '\"' -f4", returnStdout: true).trim()
                    env.PREVIOUS_APP_VERSION = PREVIOUS_APP_VERSION

                    // Ambil nama app dari package.json
                    def APP_NAME = sh(script: "grep '\"name\"' package.json | head -1 | cut -d '\"' -f4", returnStdout: true).trim()
                    env.APP_NAME = APP_NAME

                    echo "✅ Current Version: $APP_VERSION"
                    echo "🔙 Previous Version: $PREVIOUS_APP_VERSION"
                    echo "📦 App Name: $APP_NAME"
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    sh "docker build --build-arg APP_VERSION=$APP_VERSION -t $REGISTRY:v$APP_VERSION ."
                    sh "docker push $REGISTRY:v$APP_VERSION"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    deployToSSH(
                        configName: 'LINUX-DOCKER-102',
                        deploymentMode: 'cannary', // atau 'full' nanti bisa dibuat parameter pipeline juga
                        appName: env.APP_NAME,
                        appVersion: env.APP_VERSION,
                        previousVersion: env.PREVIOUS_APP_VERSION
                    )
                }
            }
        }
    }
}

// Fungsi deployToSSH dengan parameter lengkap
def deployToSSH(configName, deploymentMode, appName, appVersion, previousVersion) {
    sshPublisher(
        failOnError: true,
        publishers: [
            sshPublisherDesc(
                configName: configName,
                transfers: [
                    sshTransfer(
                        sourceFiles: 'deployment/**',
                        removePrefix: 'deployment',
                        remoteDirectory: '/home/deployersakti',
                        execCommand: """
                            cd /home/deployersakti &&
                            cp /home/deployersakti/deployment-app/.env ./deployment/.env &&
                            chmod +x ./deployment/*.sh &&
                            ./deployment/manage-docker-container.sh \\
                                --mode=${deploymentMode} \\
                                --app-name=${appName} \\
                                --app-version=${appVersion} \\
                                --app-previous-version=${previousVersion} &&
                            rm -rf ./deployment/*
                        """
                    )
                ],
                verbose: true
            )
        ]
    )
}
