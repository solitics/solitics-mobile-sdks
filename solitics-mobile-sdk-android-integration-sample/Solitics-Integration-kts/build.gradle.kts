import org.jfrog.gradle.plugin.artifactory.dsl.ArtifactoryPluginConvention
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id("com.android.application") version "8.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.10" apply false
    // Make sure that you have the Google services Gradle plugin dependency
    id("com.google.gms.google-services") version "4.4.0" apply false
    // Add the dependency for the Crashlytics Gradle plugin
    id("com.google.firebase.crashlytics") version "2.9.9" apply false

    id("com.jfrog.artifactory") version "5.+"
}

configure<ArtifactoryPluginConvention> {
    val contextUrl = providers.gradleProperty("artifactory.solitics.rootURL").orNull
    setContextUrl(contextUrl)
}

allprojects {

    apply {
        plugin("com.jfrog.artifactory")
    }

    afterEvaluate {
        configurations.all {
            resolutionStrategy {
                cacheDynamicVersionsFor(0, TimeUnit.SECONDS)
                cacheChangingModulesFor(0, TimeUnit.SECONDS)
            }
        }

        tasks.withType<JavaCompile> {
            options.encoding = "UTF-8"
            options.compilerArgs.addAll(listOf("-Xlint:unchecked", "-Xlint:deprecation", "-Xlint:-options"))
        }

        tasks.withType<Javadoc> {
            isFailOnError = false

            options {
                this.encoding = "UTF-8"
                // addStringOption("Xdoclint:none", "-quiet")
                // addStringOption("charSet", "UTF-8")
            }
        }
    }
}