pipeline {
  agent any

// Don't forget to make use in the relevant places:
// copyArtifacts filter: '...your..terraform..state..path...', projectName: '${JOB_NAME}'
// archiveArtifacts artifacts: '...your..terraform..state..path...', onlyIfSuccessful: true

  stages {
    stage('Terraform Init & Plan'){
        when { anyOf {branch "master";branch "dev";changeRequest()} }
        steps {
            copyArtifacts filter: 'infra/dev/terraform.tfstate', projectName: '${JOB_NAME}'
            sh '''
            if [ "$BRANCH_NAME" = "master" ] || [ "$CHANGE_TARGET" = "master" ]; then
                cd infra/prod
            else
                cd infra/dev
            fi

            terraform init
            terraform plan
            '''
        }
    }

    stage('Terraform Apply'){
        when { anyOf {branch "master";branch "dev"} }
        input {
            message "Do you want to proceed for infrastructure provisioning?"
        }
        steps {
            sh '''
            copyArtifacts filter: 'infra/dev/terraform.tfstate', projectName:- '${JOB_NAME}'
            if [ "$BRANCH_NAME" = "master" ] || [ "$CHANGE_TARGET" = "master" ]; then
                INFRA_ENV=infra/prod
            else
                INFRA_ENV=infra/dev
            fi

            cd$INFRA_ENV
            terraform apply -auto-approve
            '''
            archiveArtifacts artifacts: 'infra/dev/terraform.tfstate', onlyIfSuccessful: true
        }
    }
  }
}


