
// pipeline {
//     agent any

//     stages {
//         stage('Get Commit Differences') {
//             steps {
//                 script {
//                     // Print environment information
//                     sh 'echo "Workspace: $WORKSPACE"'
//                     sh 'echo "PATH: $PATH"'
//                     sh 'which git'
//                     sh 'which terraform'
                    
//                     // Get the commit SHAs
//                     def currentCommit = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
//                     def previousCommit = sh(script: 'git rev-parse HEAD~1', returnStdout: true).trim()
                    
//                     echo "Current commit: ${currentCommit}"
//                     echo "Previous commit: ${previousCommit}"
                    
//                     // Get the difference between commits
//                     def diff = sh(script: "git diff --name-only ${previousCommit} ${currentCommit}", returnStdout: true).trim()
                    
//                     if (diff) {
//                         echo "Changed files:\n${diff}"
                        
//                         diff.split('\n').each { file ->
//                             if (file != 'Jenkinsfile') {
//                                 def dir = file.contains('/') ? file.substring(0, file.lastIndexOf('/')) : '.'
                                
//                                 echo "Processing directory: ${dir}"
                                
//                                 sh """
//                                     set -xe
//                                     cd "${WORKSPACE}/${dir}" || { echo "Failed to change directory to ${dir}"; exit 1; }
//                                     echo "Current directory: \$(pwd)"
//                                     ls -la
                                    
//                                     if [ -f terraform.tf ] || [ -f main.tf ]; then
//                                         echo "Terraform files found. Proceeding with Terraform commands."
//                                         terraform version || { echo "Terraform not found or not in PATH"; exit 1; }
//                                         terraform init || { echo "Terraform init failed"; exit 1; }
//                                         terraform plan || { echo "Terraform plan failed"; exit 1; }
//                                     else
//                                         echo "No Terraform configuration found in ${dir}"
//                                     fi
//                                 """
//                             }
//                         }
//                     } else {
//                         echo 'No changes detected between commits.'
//                     }
//                 }
//             }
//         }

//         stage('Terraform Apply') {
//             steps {
//                 script {
//                     // Prompt for approval before applying changes
//                     def userInput = input message: 'Do you want to proceed with terraform apply?', ok: 'Apply', parameters: [choice(name: 'Approval', choices: ['No', 'Yes'], description: 'Choose Yes to proceed or No to abort')]
                    
//                     if (userInput == 'Yes') {
//                         echo 'Applying Terraform changes...'
                        
//                         // Get the difference between commits again
//                         def currentCommit = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
//                         def previousCommit = sh(script: 'git rev-parse HEAD~1', returnStdout: true).trim()
//                         def diff = sh(script: "git diff --name-only ${previousCommit} ${currentCommit}", returnStdout: true).trim()
                        
//                         if (diff) {
//                             diff.split('\n').each { file ->
//                                 if (file != 'Jenkinsfile') {
//                                     def dir = file.contains('/') ? file.substring(0, file.lastIndexOf('/')) : '.'
                                    
//                                     sh """
//                                         set -xe
//                                         cd "${WORKSPACE}/${dir}" || { echo "Failed to change directory to ${dir}"; exit 1; }
//                                         echo "Current directory: \$(pwd)"
//                                         ls -la

//                                         if [ -f terraform.tf ] || [ -f main.tf ]; then
//                                             echo "Terraform files found. Proceeding with Terraform apply."
//                                             terraform version || { echo "Terraform not found or not in PATH"; exit 1; }
//                                             terraform apply -auto-approve || { echo "Terraform apply failed"; exit 1; }
//                                         else
//                                             echo "No Terraform configuration found in ${dir}"
//                                         fi
//                                     """
//                                 }
//                             }
//                         } else {
//                             echo 'No changes detected between commits.'
//                         }
//                     } else {
//                         echo 'Terraform apply aborted by user.'
//                     }
//                 }
//             }
//         }
//     }
    
//     post {
//         always {
//             echo "Pipeline completed. Status: ${currentBuild.result}"
//         }
//     }
// }

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

        stage('Approval Stage') {
            steps {
                // Approval input with security policy
                script {
                    // Set branch name using GIT_BRANCH
                    def branchName = env.GIT_BRANCH ? env.GIT_BRANCH.replaceFirst(/^origin\//, '') : 'unknown'
                    echo "DEBUG: Current branch name: ${branchName}"

                    def inputResponse = input message: 'Proceed with Approval Stage?',
                                        submitterParameter: 'APPROVER',
                                        submitter: 'wiai-approver',
                                        parameters: [booleanParam(description: 'Approval', name: 'APPROVAL')]
                    // Extract approval status from input response
                    def approval = inputResponse['APPROVAL']
                    // Extract user who approved
                    def approver = inputResponse['APPROVER']
                    
                    // Debug: Print approval and approver information
                    echo "DEBUG: Approval: ${approval}, Approver: ${approver}, Branch: ${branchName}"
                    
                    // Check if the approval was granted by the admin
                    if (approver == 'wiai-approver' && approval && branchName == 'jenkins') {
                        echo 'Approval granted by admin. Proceeding to Deploy Stage...'
                    } else {
                        echo "Approval denied. Only 'jenkins' branch is allowed or not provided by the correct submitter. Stopping the pipeline."
                        error("Approval denied. Only 'jenkins' branch is allowed or not provided by the correct submitter.")
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
