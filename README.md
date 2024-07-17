# jenkins-pipeline
// pipeline {
//   agent any

//   stages {
//     stage('Get Commit Differences') {
//       steps {
//         script {
//           // Get the commit SHAs from environment variables
//           def currentCommit = env.GIT_COMMIT
//           def previousCommit = env.GIT_PREVIOUS_COMMIT

//           // Check if there is a previous commit
//           if (previousCommit == null) {
//             echo 'No previous commit found. This might be the first build.'
//           } else {
//             // Get the difference between commits
//             def diff = sh(script: "git diff --name-only ${previousCommit} ${currentCommit}", returnStdout: true)

//             // Print the difference 
//             if (diff.trim() == '') {
//               echo 'No changes detected between commits.'
//             } else {
//               echo "Changed files:\n${diff}"

//               // Loop through changed files (excluding Jenkinsfile)
//               for (file in diff.split('\n')) {
//                 if (file != 'Jenkinsfile') {
//                   // Get directory name
//                   def dir = file.split('/').minus(file.split('/').last())
//                   if (dir) {
//                     dir = dir.join('/')
//                   } else {
//                     dir = '.'
//                   }
//                   sh """
//                       cd "${WORKSPACE}/${dir}" || exit 1
//                       echo "Changes detected in directory: ${pwd()}"
//                       sh "chmod +x ."
//                       echo "Applying terraform init command:"
//                       sh "terraform init"
//                       echo "Applying terraform plan command:"
//                       sh "terraform plan"
//                   """
//                 }
//               }
//             }
//           }
//         }
//       }
//     }
//   }
// }

// pipeline {
//   agent any

//   // properties([
//   //     pipelineTriggers([
//   //         githubPush()
//   //     ])
//   // ])

//   stages {
//     stage('Get Commit Differences') {
//       steps {
//         script {
//           // Get the commit SHAs from environment variables
//           def currentCommit = env.GIT_COMMIT
//           def previousCommit = env.GIT_PREVIOUS_COMMIT

//           // Check if there is a previous commit
//           if (previousCommit == null) {
//             echo 'No previous commit found. This might be the first build.'
//           } else {
//             // Get the difference between commits
//             def diff = sh(script: "git diff --name-only ${previousCommit} ${currentCommit}", returnStdout: true)

//             // Print the difference
//             if (diff.trim() == '') {
//               echo 'No changes detected between commits.'
//             } else {
//               echo "Changed files:\n${diff}"

//               // Loop through changed files (excluding Jenkinsfile)
//               for (file in diff.split('\n')) {
//                 if (file != 'Jenkinsfile') {
//                   // Get directory name
//                   def dir = file.split('/').minus(file.split('/').last())
//                   if (dir) {
//                     dir = dir.join('/')
//                   } else {
//                     dir = '.'
//                   }
                  
//                   // Use dir step to change directory
//                   dir(dir) {
//                     echo "Changes detected in directory: ${pwd()}"
//                     sh "chmod +x ."
//                     echo "Applying terraform init command:"
//                     sh "terraform init"
//                     echo "Applying terraform plan command:"
//                     sh "terraform plan"
//                   }
//                 }
//               }
//             }
//           }
//         }
//       }
//     }
//   }
// }