pipeline {
    agent any

    parameters {
        choice(
            name: 'TARGET_TYPE',
            choices: ['group', 'project'],
            description: 'group → todos los repos del grupo | project → repos concretos'
        )
        string(
            name: 'TARGET_URL',
            defaultValue: '',
            description: 'URL del grupo o repo de GitLab'
        )
        string(
            name: 'JENKINS_WEBHOOK_URL',
            defaultValue: 'https://jenkins.example.com/gitlab-webhook/',
            description: 'URL del webhook de Jenkins'
        )
        choice(
            name: 'TF_ACTION',
            choices: ['plan', 'apply'],
            description: 'plan → solo muestra los cambios | apply → aplica los cambios'
        )
    }

    environment {
        TF_VAR_gitlab_token        = credentials('gitlab-api-token')
        TF_VAR_target_type         = "${params.TARGET_TYPE}"
        TF_VAR_jenkins_webhook_url = "${params.JENKINS_WEBHOOK_URL}"
    }

    stages {

        stage('Preparar variables') {
            steps {
                script {
                    def rawInput = params.TARGET_URL.trim()

                    def cleanPath = rawInput
                        .replaceAll(/https?:\/\/[^\/]+\/git\//, '')
                        .replaceAll(/\/$/, '')

                    if (params.TARGET_TYPE == 'group') {
                        env.TF_VAR_group_path    = cleanPath
                        env.TF_VAR_project_paths = '[]'
                    } else {
                        def paths = cleanPath.split(',')
                            .collect { "\"${it.trim()}\"" }
                            .join(',')
                        env.TF_VAR_project_paths = "[${paths}]"
                        env.TF_VAR_group_path    = ''
                    }

                    echo "Modo      : ${params.TARGET_TYPE}"
                    echo "group_path: ${env.TF_VAR_group_path}"
                    echo "projects  : ${env.TF_VAR_project_paths}"
                    echo "TF_ACTION : ${params.TF_ACTION}"
                }
            }
        }

        stage('tofu init') {
            steps {
                sh 'tofu init -input=false'
            }
        }

        stage('tofu plan') {
            steps {
                sh 'tofu plan -input=false -out=tfplan'
            }
        }

        stage('tofu apply') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                sh 'tofu apply -input=false tfplan'
            }
        }
    }

    post {
        success { echo "Webhooks configurados correctamente" }
        failure  { echo "Error al configurar webhooks" }
    }
}
