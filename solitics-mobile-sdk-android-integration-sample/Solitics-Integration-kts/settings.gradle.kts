pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven("https://plugins.gradle.org/m2/")
    }
}
dependencyResolutionManagement {
    val base_key = "artifactory.solitics"
    val root_url = providers.gradleProperty("${base_key}.rootURL").orNull
    val repo_key = providers.gradleProperty("${base_key}.consumer.repoKey").orNull
    val artifactoryUsername = providers.gradleProperty("${base_key}.consumer.username").orNull
    val artifactoryPassword = providers.gradleProperty("${base_key}.consumer.password") .orNull

    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()

        maven() {
            url = uri("${root_url}/${repo_key}") // Replace with your Maven repository URL
            credentials {
                username = artifactoryUsername
                password = artifactoryPassword
            }
        }
    }
}

rootProject.name = "Solitics-Integration-kts"
include(":app")
 