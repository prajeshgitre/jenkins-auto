
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

        stage('Approval') {
            steps {
                script {
                    // Prompt for user approval before proceeding to Terraform Apply
                    def userInput = input message: 'Changes detected. Do you want to proceed with Terraform apply?', ok: 'Apply', parameters: [choice(name: 'Approval', choices: ['No', 'Yes'], description: 'Choose Yes to proceed or No to abort')]
                    
                    if (userInput == 'Yes') {
                        echo 'Approval granted. Proceeding to Terraform Apply...'
                    } else {
                        echo 'Terraform apply aborted by user.'
                        // Set build status to aborted or unstable to indicate user abort
                        currentBuild.result = 'ABORTED' // Or 'UNSTABLE'
                        return
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    echo 'Applying Terraform changes...'
                    
                    // Get the difference between commits again
                    def currentCommit = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    def previousCommit = sh(script: 'git rev-parse HEAD~1', returnStdout: true).trim()
                    def diff = sh(script: "git diff --name-only ${previousCommit} ${currentCommit}", returnStdout: true).trim()
                    
                    if (diff) {
                        diff.split('\n').each { file ->
                            if (file != 'Jenkinsfile') {
                                def dir = file.contains('/') ? file.substring(0, file.lastIndexOf('/')) : '.'
                                
                                sh """
                                    set -xe
                                    cd "${WORKSPACE}/${dir}" || { echo "Failed to change directory to ${dir}"; exit 1; }
                                    echo "Current directory: \$(pwd)"
                                    ls -la

                                    if [ -f terraform.tf ] || [ -f main.tf ]; then
                                        echo "Terraform files found. Proceeding with Terraform apply."
                                        terraform version || { echo "Terraform not found or not in PATH"; exit 1; }
                                        terraform apply -auto-approve || { echo "Terraform apply failed"; exit 1; }
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
