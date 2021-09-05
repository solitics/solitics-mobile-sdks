# solitics-mobile-sdk-android
 
Solitics SDK is a library that allow it's users to perform Real-Time Events Reporting

## Installation - Gradle
1. Solitics SDK requires the following permissions to be granted:
    ```xml
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.INTERNET" />
    ```
   
2. In build.gradle (project):
    ```groovy
    buildscript {
        repositories {
            maven {  
                url 'https://plugins.gradle.org/m2/'  
            }
        }
        dependencies {  
            classpath 'org.jfrog.buildinfo:build-info-extractor-gradle:4.20.0'
        }
    }
    
    // Add outside of any scope 
    ext {
        artifactory_url      = 'https://soliticsmobilesdk.jfrog.io/artifactory'
        artifactory_repoKey  = 'android.solitics.mobile.releases'
        artifactory_username = System.getenv('solitics.consumer.username') ?: findProperty('solitics.consumer.username')
        artifactory_password = System.getenv('solitics.consumer.password') ?: findProperty('solitics.consumer.password')
    }
    allprojects {
        ...
        apply plugin: "com.jfrog.artifactory"
        ...
        repositories {
            ...
             mavenLocal()
             google()            
        }
    }
    artifactory {
        contextUrl = artifactory_url // The base Artifactory URL if not overridden by the publisher/resolver
        publish {}
        resolve {
            repository {
                repoKey  = artifactory_repoKey
                username = artifactory_username
                password = artifactory_password
                maven = true
            }
        }
    }
    ```
   3. Add the following to the module (application) level gradle file:

       ```groovy
       dependencies {
           ...
           // Remote dependencies
           implementation 'com.solitics:solitics.sdk:1.0.2.+'
       }
       ```
   4. * Navigate to the global gradle.properties file.
       The global gradle.properties file can be found in "your user folder/.gradle/" 
       **Do note** the .gradle folder is hidden by default. 
       * Add two properties to that file:
       ```groovy
       solitics.consumer.username=YOUR_USERNAME
       solitics.consumer.password=YOUR_PASSWORD
       ```
       * Replace YOUR_USERNAME and YOUR_PASSWORD with your credentials.
       Global properties file is not committed into git.
       * Save and close the file.

   5. Click "Sync project with Gradle files".


## Installation - Manual
In order to use Solitics SDK , you will also need to add it to your project:

1. Open your project in Android Studio.

2. Add the SoliticsSDK AAR to the project:
   - Click File -> Project Structure and choose the Modules tab.
   - Click on the + and in the "New Module" window and choose "Import .JAR/AAR package" option.
   - In the next window, click the folder icon, and navigate to the SoliticsSDK aar location.
   - Select the aar file and click ok. 
   - In the subproject name text field type "solitics.sdk". 
   - click Finish and close the project structure window.
   
3. In your module (application) level Gradle file add the following dependencies:

    ```groovy
        dependencies {
           implementation project(path: ':solitics.sdk')
           
           implementation "org.jetbrains.kotlin:kotlin-stdlib:1.4.31"
        
           implementation 'com.neovisionaries:nv-websocket-client:2.10'
        
           implementation 'com.google.android.material:material:1.3.0'
        
           implementation 'androidx.core:core-ktx:1.5.0'
           implementation 'androidx.appcompat:appcompat:1.3.0'
           implementation 'androidx.constraintlayout:constraintlayout:2.0.4'
        
           implementation 'com.google.code.gson:gson:2.8.6'
           implementation 'com.squareup.retrofit2:retrofit:2.9.0'
           implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
           implementation 'com.squareup.okhttp3:logging-interceptor:4.7.2'
        }
    ```
    Note: the path in the local dependencies should point to the actual aar file, change as needed. 

4. In addition, you should add javadoc and sources to have correct code completions in your IDE. To do this you should go
 
to *Project View -> External Libraries* and right click on "artifacts:solitics.sdk". You should choose *Library Properties...*

    ##### Project View
    In this window you should press on "Add" button and choose solitics.sdk-javadoc and solitics.sdk-sources on disk.
    
    ##### Library Properties
    After you have added them you will see files added as follows:
    
    ##### Added sources and Javadoc
    After that, you should press "Ok"         

5. Click "Sync project with Gradle files", Build -> "Clean project" and Build -> "Rebuild project"

## Code Integration - Sample

1. The library perform an automatic login action if possible
2. If the system does not contain any login information the user will need to call the following method:
    ```kotlin
        val loginInfo = LoginMetadata(
            email = "sample@example.com",
            customFields = "some string",
            keyType = "some keyType",
            keyValue = "some keyValue",
            brand = "some brand",
            branch = "some branch",
            txAmount = -9999999999999999 ,
            subscribedId = -9999999999999999 ,
            memberId = "some member id",
            popupToken = "token"
        )
        val response = SoliticsSDK.onLogin(loginMetadata)
    ```
   Note: This is a synchronous method
   
3. Mandatory parameters combinations:
       Option 1
        • branch (for authentication)
        • email (for double authentication)
        • brand (Token)
        • popupToken
        • customFields     
        • memberId
       
       Option 2
        • branch (for authentication)
        • email (for double authentication) 
        • brand (Token)
        • popupToken
        • customFields
        • keyType
        • keyValue
                       
4. On EmitEvent
    This method allows you to report to Solitics any user event which takes place in the Mobile App: ‘Button Click’, ‘Page Change’, etc.
    
    ```kotlin
        SoliticsSDK.onEmitEvent(
            "txType",
            1234 /* txAmount */ ,
            "customFields"
        )
    ```
