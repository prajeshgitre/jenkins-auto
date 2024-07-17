

pipeline {
    agent any
    
    
    stages {
        stage('Get Commit Differences') {
            steps {
                script {
                    // Print environment information
                    sh 'echo "Workspace: $WORKSPACE"'
                    sh 'echo "PATH: $PATH"'
                    sh 'which git'
                    sh 'which terraform'
                    
                    // Get the commit SHAs
                    def currentCommit = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    def previousCommit = sh(script: 'git rev-parse HEAD~1', returnStdout: true).trim()
                    
                    echo "Current commit: ${currentCommit}"
                    echo "Previous commit: ${previousCommit}"
                    
                    // Get the difference between commits
                    def diff = sh(script: "git diff --name-only ${previousCommit} ${currentCommit}", returnStdout: true).trim()
                    
                    if (diff) {
                        echo "Changed files:\n${diff}"
                        
                        diff.split('\n').each { file ->
                            if (file != 'Jenkinsfile') {
                                def dir = file.contains('/') ? file.substring(0, file.lastIndexOf('/')) : '.'
                                
                                echo "Processing directory: ${dir}"
                                
                                sh """
                                    set -xe
                                    cd "${WORKSPACE}/${dir}" || { echo "Failed to change directory to ${dir}"; exit 1; }
                                    echo "Current directory: \$(pwd)"
                                    ls -la
                                    
                                    if [ -f terraform.tf ] || [ -f main.tf ]; then
                                        echo "Terraform files found. Proceeding with Terraform commands."
                                        terraform version || { echo "Terraform not found or not in PATH"; exit 1; }
                                        terraform init || { echo "Terraform init failed"; exit 1; }
                                        terraform plan || { echo "Terraform plan failed"; exit 1; }
                                    else
                                        echo "No Terraform configuration found in ${dir}"
                                    fi
                                """
                            }
                        }
                    } else {
                        echo 'No changes detected between commits.'
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline completed. Status: ${currentBuild.result}"
        }
    }
}