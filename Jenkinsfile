pipeline {
    agent any

    stages {
        stage('Extract App Info') {
            steps {
                script {
                    // Ambil versi sekarang dari package.json
                    env.APP_VERSION = "1.10.0"

                    // Ambil versi sebelumnya dari commit sebelumnya
                    env.PREVIOUS_APP_VERSION = "1.9.0"

                    // Ambil nama app dari package.json
                    env.APP_NAME = "app.testing"

                    echo "✅ Current Version: $APP_VERSION"
                    echo "🔙 Previous Version: $PREVIOUS_APP_VERSION"
                    echo "📦 App Name: $APP_NAME"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    deployToSSH(
                        configName: 'LINUX-DOCKER-102'
                    )
                }
            }
        }
    }
}

// Fungsi deployToSSH dengan parameter lengkap
def deployToSSH(configName) {
    sshPublisher(
        failOnError: true,
        publishers: [
            sshPublisherDesc(
                configName: configName,
                transfers: [
                    sshTransfer(
                        execCommand: """
                            cd /home/deployersakti &&
                            cp /home/deployersakti/deployment-app/.env ./deployment/.env &&
                            chmod +x ./deployment/*.sh
                        """
                    )
                ],
                verbose: true
            )
        ]
    )
}
