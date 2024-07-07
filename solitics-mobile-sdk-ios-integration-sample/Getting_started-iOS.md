# solitics-sdk-ios - Getting started

As a marketer, an immediate response to a customer action is crucial the moment an action takes place.

Solitics, a personalized marketing automation platform, enables you to react in real-time to events fired from your client or server.

- [**Installation**](#installation)
    - [cocoapods](#-Dependency-Management-Systems)
    - [Manual](#---Manual)
- [**Usage - Sample**](#Usage---Sample)
- [**Migration guide**](#Migration-guide)


## Installation
### Dependency Management Systems
1. Install the cocoapods via gem if needed
	* Open terminal 
	* Type `$ [sudo] gem install cocoapods`
	* Press enter

2. Install the artifactory cocoapods plugin gem
	* Open terminal 
	* Type `$ [sudo] gem install cocoapods-art`
	* Press enter

3. Add your artifactory credential to the .netrc file.

    **This step is no longer needed as the security policy has changed.**

	 * Open the `.netrc` file. The `.netrc` file is a hidden file located under the user folder.
     * Create the file if you don't already have one. 
	 * Add the following credentials to the file:
	 ```
     machine soliticsmobilesdk.jfrog.io
     login YOUR_USERNAME
     password YOUR_API_Key
     ``` 
    * Save and close the file.

    Alternativly you can add the following to your `.netrc` file, this is useful in case you work with several repos on the same jfrog that have diffrent password.
    ```
    export COCOAPODS_ART_CREDENTIALS=YOUR_USERNAME:YOUR_API_Key
    ```

4. Add artifactory specs repo
    * Open terminal 
    * Type `$ pod repo-art add ios.solitics.mobile.releases "https://soliticsmobilesdk.jfrog.io/artifactory/api/pods/ios.solitics.mobile.releases"`
    * Press enter

5. Add the artifactory plugin to the podfile.
    At the top of your podfile add the following lines:
    ```ruby
    plugin 'cocoapods-art', :sources => [
        'ios.solitics.mobile.releases'
    ]
    ```

6. add the pod to the podfile
    ```ruby
    target ‘YOUR_PROJECT’ do
        …
        pod 'SoliticsSDK'
    end
    ```

7. In the terminal run `pod install`
    ### Note for Mac M1 users:
    Mac M1 architecture is not directly compatible with Cocoapods. If you encounter issues when installing pods, you can solve it by running:
    - sudo arch -x86_64 gem install ffi
    - arch -x86_64 pod install
    These commands install the ffi package, to load dynamically-linked libraries and let you run the pod install properly, and runs pod install with the proper architecture.

## Usage - Sample
### Report Real-Time Events in Two Simple Steps
Report real time events to Solitics very easy – all you need to do is follow two

#### steps:
1. Report a User Login - Once the user logs-in to your web client, report Solitics by invoking the loginSuccess method.
This method should be called once only.

2. Report the User’s Actions - Report Solitics on any user’s action you would like to track. You may use one of the predefined methods, such as page-entered or button-clicked, or use the Emit method, for custom events.

## OnLogin action
``` Swift
    func sendSignInRequest(for userInput: SignInUserInput)
    {
        let memberId         : Int?     = Int   (123456)
        let transactionAmount: Double?  = Double(567.9)
        
        let login = LoginRequest(
            brand            : "Fashion",
            branch           : "Fashion_Branch",
            email            : "demo@solitics.com",
            customFields     : "{\"page\":\"demoPopup.html\",\"fullUrl\":\"https://s3-eu-west-3.amazonaws.com/demo_popup/demoPopup.html\"}",
            keyType          : "userInput.keyType,"
            keyValue         : "userInput.keyValue",
            transactionAmount: transactionAmount,
            memberId         : memberId,
            token            : "Wf9fsDARzdtCqDFJ9cVKrmuF"
        )
        
        Solitics.onLogin(login) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result
            {
            case .success           :
                // Do something after login success
            case .failure(let error):
                // Do something after login failure
            }
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

## OnEmitEvent action
``` Swift
    func sendEventRequest(inputData: OnEmitEventUserInput)
    {
        Solitics.onEmitEvent(
            txType	    : inputData.txType,
            txAmount    : inputData.txAmount,
            customFields: inputData.customFields) { [weak self] result in
            
            guard let strongSelf = self else { return }
            switch result
            {
            case .success(let loginResult):
                // Do something after event success
                break
            case .failure(let error):
                // Do something after event failure
            break
            }
        }
    }
```

## OnLogoutEvent action
Logs out the member from Solitics platform.
Note: Invoke this method once the user session ends when a user logs-out from your web client.

``` Swift
    func signOut()
    {
        Solitics.onLogout()
    }
```

6. Dismiss Solitics Popup in code

This method can be used to trigger a dismiss action in code. 
Note: make sure that you call this method on the main application thread

```Swift
    Solitics.dismissSoliticsPopup()
```

## Handle push notifications
* You should first conform to 'UNUserNotificationCenterDelegate' to be notified by the system about this callback.

#### Handle notifications for foreground app state

``` Swift
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) 
    {
        let payload = notification.request.content.userInfo
        SoliticsSDK.Solitics.didClickPushNotification(for: payload)
        ...
    }
```

#### Handle notifications for background or terminated app state
* You should first add a new 'NotificationService' target (a.k.a Notification Service Extension)
* After the target is created a new directory will be created with the name provided, a default file can be seen by the name 'NotificationService.swift'. 
  Add the Solitics method invocation here.


``` Swift
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void)
    {
        SoliticsSDK.Solitics.didReceivePushNotificationRequest(for: request)
        ...
    }
```

* You should first conform to 'UNUserNotificationCenterDelegate' to be notified by the system about this callback.
* Called when the user click the notification

``` Swift
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        SoliticsSDK.Solitics.didReceivePushNotificationResponse(for: response)
    }
```

## Advanced usages
## SoliticsLogListener
An optional element allowing the user to be notified of any meaningful socket communication, including popup message arrivals and related content
``` Swift
    Solitics.register(SoliticsLogListener: <an object implemnting SoliticsLogListener protocol>)
```
``` Swift
    Solitics.remove(SoliticsLogListener: <an object implemnting SoliticsLogListener protocol>)
```


## SoliticsPopupDelegate
An optional element allowing the user to decide if a popup should be presented & to be notified when a popup is displayed, dismissed or an item in the popup is clicked

NOTE: this is a weak pointer
``` Swift
    Solitics.delegate = <an object implemnting SoliticsPopupDelegate protocol>
```

For more information see the demo application

## Migration guide
### Solitics SDK 2.0.0

Latest changes in the Soitics SDK ontain breaking changes to some elements of the system, i.e. you are no longer able to manually control popup presentation and dismisal.

To control popup presentation use SoliticsPopupDelagate API, see example above.
