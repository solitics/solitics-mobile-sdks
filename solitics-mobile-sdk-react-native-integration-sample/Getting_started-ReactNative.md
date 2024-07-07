# react-native-solitics-sdk

As a marketer, an immediate response to a customer action is crucial the moment an action takes place.

Solitics, a personalized marketing automation platform, enables you to react in real-time to events fired from your client or server.

## Installation

To properly install this package there are several steps that are needed:
1. General - install the package via NPM

    **The credential related part is no longer needed as the security policy has changed.**

    * Go to the .npmrc file and paste in the next snippet at the end of the file. Please note that this file is hidden by default.
    ```sh
    @solitics:registry=https://soliticsmobilesdk.jfrog.io/artifactory/api/npm/react.native.solitics.mobile.releases/
    //soliticsmobilesdk.jfrog.io/artifactory/api/npm/react.native.solitics.mobile.releases/:_password=YOUR_PASSWORD
    //soliticsmobilesdk.jfrog.io/artifactory/api/npm/react.native.solitics.mobile.releases/:username=YOUR_USERNAME
    //soliticsmobilesdk.jfrog.io/artifactory/api/npm/react.native.solitics.mobile.releases/:email=YOUR_EMAIL
    //soliticsmobilesdk.jfrog.io/artifactory/api/npm/react.native.solitics.mobile.releases/:always-auth=true
    ```
    Please make sure you replace placeholder values with your actual credential information.
    * Get a handle on a terminal located on your project directory and run
    ```sh
    npm install @solitics/react-native-solitics-sdk
    ```
    You should see that 1 package was added to your project.
2. For iOS Platform support:
3. Install the cocoapods via gem if needed
	* Open terminal 
	* Type `$ [sudo] gem install cocoapods`
	* Press enter

4. Install the artifactory cocoapods plugin gem
	* Open terminal 
	* Type `$ [sudo] gem install cocoapods-art`
	* Press enter

5. Add your artifactory credential to the .netrc file.
	 * Open the `.netrc` file. The `.netrc` file is a hidden file located under the user folder.
     * Create the file if you don't already have one. 
	 * Add the following credentials to the file:
	 ```
     machine soliticsmobilesdk.jfrog.io
     login YOUR_USERNAME
     password YOUR_API_Key
     ``` 
    * Save and close the file.

6. Add artifactory specs repo
    * Open terminal 
    * Type `$ pod repo-art add ios.solitics.mobile.releases "https://soliticsmobilesdk.jfrog.io/artifactory/api/pods/ios.solitics.mobile.releases"`
    * Press enter

7. Add the artifactory plugin to the podfile.
    At the top of your podfile add the following lines:
    ```ruby
    plugin 'cocoapods-art', :sources => [
        'ios.solitics.mobile.releases'
    ]
    ```

8. comment out the flipper related code in your Podfile, Solitics SDK is a dynamic framework, you'll need to have your project setup accordingly
  ```ruby
    #  # Enables Flipper.
    #  #
    #  # Note that if you have use_frameworks! enabled, Flipper will not work and
    #  # you should disable these next few lines.
    #  use_flipper!
    #  post_install do |installer|
    #    flipper_post_install(installer)
    #  end
  ```
9. In the terminal run `pod install`
### Note for Mac M1 users:
    Mac M1 architecture is not directly compatible with Cocoapods. If you encounter issues when installing pods, you can solve it by running:
    - sudo arch -x86_64 gem install ffi
    - arch -x86_64 pod install
    These commands install the ffi package, to load dynamically-linked libraries and let you run the pod install properly, and runs pod install with the proper architecture.

### Note: for more information see the iOS integration instructions

10. For Android Platform support:
   
11. In build.gradle (project):
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
        // No longer needed as the security policy has changed
        // artifactory_username = System.getenv('solitics.consumer.username') ?: findProperty('solitics.consumer.username')
        // artifactory_password = System.getenv('solitics.consumer.password') ?: findProperty('solitics.consumer.password')
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
                // username = artifactory_username // No longer needed as the security policy has changed
                // password = artifactory_password // No longer needed as the security policy has changed
                maven = true
            }
        }
    }
    ```
12. * 
    **The credential related part is no longer needed as the security policy has changed.**
    
    Navigate to the global gradle.properties file.
       The global gradle.properties file can be found in "your user root folder/.gradle/" 
    **Do note** the .gradle folder is hidden by default. 
    * Add two properties to that file:
    ```groovy
    solitics.consumer.username=YOUR_USERNAME
    solitics.consumer.password=YOUR_PASSWORD
    ```
    * Replace YOUR_USERNAME and YOUR_PASSWORD with your credentials.
    Global properties file is not committed into git.
    * Save and close the file.

13. Click "Sync project with Gradle files".


## Usage - SDK import & initialization

```typescript
// first, import the SDK
import SoliticsSdk from "@solitics/react-native-solitics-sdk";

// calling the initSDK method is crucial for it to work as intended. this method would only go through the initialization process once and will ignore any calls if the SDK is initialized.
SoliticsSDK.initSDK()
```

## Usage - Common use cases
### Report Real-Time Events in Two Simple Steps
Report real time events to Solitics very easy – all you need to do is follow two

#### steps:
1. Login a user by calling the onLogin method, this method returns a Promise object that is resolved with a user token when successful or gets rejected with an error in case of failure.

2. Report the User’s Actions - Report Solitics on any user’s action you would like to track using the onEmitEvent method. Just likethe onLogin method, this method returns a Promise.

## OnLogin action
``` typescript
    const onLoginButtonClicked = async (
    email: String,
    customFields: String,
    keyType: String,
    keyValue: String,
    popupToken: String,
    brand: String,
    branch: String,
    txAmount: String,
    memberId: String
  ) => {
    try {
      const result = await SoliticsSDK.onLogin({
        email,
        customFields,
        keyType,
        keyValue,
        brand,
        branch,
        popupToken,
        txAmount,
        memberId
      })
      console.log(result)
      onScreenChanged(Screen.Home)
    } catch (e) {
      console.error(e)
    }
  }
```

## Login Parameters:

### ***memberId String***
The member’s unique ID as saved in the brand system (mandatory).

### ***KeyValue & KeyType String(s)***

While the default is using the memberId, you may use the keyValue and keyType instead of the main memberId.

The keyType represents a member’s unique field name, that is referred by Solitics as an alternative to the main memberId. The keyValue is the value of this field.

For example, the main memberId can by the CRM-id while the alternative id can be a database-id. When you choose to report event to Solitics with the database-id, you will use keyType=’database-id’ and keyValue=’the-db-id-value’.

When you choose to report event using the CRM-id, you’ll only use the ‘memberId’ and apply to is the =’the-crm-id’.

### ***email String***
The member’s email (mandatory and used for double authentication, unless otherwise defined in project setup).

### ***Brand String***
A mandatory name that recognizes the brand in Solitics. Provided by the Solitics team.

### ***popupToken String***
An optional unique token for displaying popups. To get the popup token of your brand, please contact Solitics.

### ***Branch String***
In projects that manage several branches – the ‘branch’ field represents the name of the branch as defined within Solitics (case sensitive). To get the exact list of branches at your brand, please contact Solitics.

### ***CustomFields String***
A JSON String for additional fields

### ***txAmount String***
<!-- TODO: a description for what txAmount is-->

## OnEmitEvent action
``` typescript
    const onSendEventButtonClicked = (txType: String, txAmount: number, customFields: String) => {
        SoliticsSDK.onEmitEvent(txType, txAmount, customFields)
          .then(() => {
            console.log("event emitted")
          })
          .catch((e: any) => {
            console.error(e)
          })
      }
```

## OnLogoutEvent action
Logs out the member from Solitics platform.
Note: Invoke this method once the user session ends when a user logs-out from your app.

``` typescript
    const onLogoutButtonClicked = () => {
        SoliticsSDK.onLogout()
        onScreenChanged(Screen.Login)
    }
```

6. Dismiss Solitics Popup in code

This method can be used to trigger a dismiss action in code.

```typescript
    SoliticsSDK.dismissSoliticsPopup()
```

## Advanced usages
## SoliticsLogListener
An optional element allowing the user to be notified of any meaningful socket communication, including popup message arrivals and related content
``` typescript
    // the message received is an object with a "logMessage" attribute containing the actual message.
    interface LogObject {
        logMessage: String
    }

    // register to get log updates.
    SoliticsSDK.registerSoliticsLogListener((message: LogMessage) => {
        console.log(message.logMessage)
    })
```
``` typescript
    // unregister from log updates when no longer needed.
    SoliticsSDK.removeSoliticsLogListener()
```


## SoliticsPopupDelegate
An optional element allowing the user to decide if a popup should be presented & to be notified when a popup is displayed, dismissed or an item in the popup is clicked

``` typescript
    // this object is a wrapper for delegate event callbacks.
    const delegate = new SoliticsSDKPopupDelegate(
        () => { console.log("popup opened callback") },
        () => { console.log("popup closed callback") },
        () => { console.log("popup clicked callback") },
        () => { console.log("popup closed for navigation callback") }
    )

    // pass the callback wrapper to invoke them when the solitics popup delegate is needed.
    SoliticsSDK.setSoliticsPopupDelegate(delegate)
```

For more information see the demo application

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

Commercial
