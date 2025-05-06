pipeline {
    parameters {
        choice(name: 'terraformAction', choices: ['apply', 'destroy'], description: 'Choose Terraform action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    stages {
        stage ('Git Checkout') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/Sooraj7340/AWS-Infra-Automation.git'
                }
            }
        }

        stage ('Plan') {
            steps {
                sh '''
                    terraform init
                    terraform plan -out=tfplan
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }

        stage ('Approval') {
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to proceed with the Terraform action?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply or Destroy') {
            when {
                expression {
                    return params.terraformAction == 'apply' || params.terraformAction == 'destroy'
                }
            }
            steps {
                script {
                    if (params.terraformAction == 'apply') {
                        sh "terraform apply -input=false tfplan"
                    } else if (params.terraformAction == 'destroy') {
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }
    }
}