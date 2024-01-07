plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")

    // Make sure that you have the Google services Gradle plugin dependency
    id("com.google.gms.google-services")
    // Add the dependency for the Crashlytics Gradle plugin
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.solitics.integration.app"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.solitics.integration.app"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        multiDexEnabled = true
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
            enableUnitTestCoverage = false
            enableAndroidTestCoverage = false
            buildConfigField("Boolean", "LINK_WATCHDOG_TO_CRASHLYTICS", "true")
        }
        release {
            isMinifyEnabled = false
            enableUnitTestCoverage = false
            enableAndroidTestCoverage = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            buildConfigField("Boolean", "LINK_WATCHDOG_TO_CRASHLYTICS", "true")
        }
    }
    buildFeatures {
        buildConfig = true
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
    flavorDimensions += listOf("default")
}

dependencies {

    implementation("com.solitics:solitics.sdk:2.1.5.19")

    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.annotation:annotation:1.7.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    implementation("androidx.navigation:navigation-fragment-ktx:2.7.6")
    implementation("androidx.navigation:navigation-ui-ktx:2.7.6")

    implementation("androidx.lifecycle:lifecycle-extensions:2.2.0")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.6.2")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.2")

    implementation("androidx.multidex:multidex:2.0.1")

    implementation("com.google.code.gson:gson:2.10")
    implementation("com.google.android.material:material:1.11.0")

    // anr-watchdog
    implementation("com.github.anrwatchdog:anrwatchdog:1.4.0")

    // Firebase
    // Import the BoM for the Firebase platform
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))

    // Declare the dependencies for the Crashlytics and Analytics libraries
    // When using the BoM, you don't specify versions in Firebase library dependencies
    implementation("com.google.firebase:firebase-crashlytics-ktx")
    implementation("com.google.firebase:firebase-analytics-ktx")

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
