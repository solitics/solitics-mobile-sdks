## solitics-sdk-ios - Getting started
### Installation - Dependency Management Systems
1. Install the cocoapods via gem if needed
	* Open terminal 
	* Type `$ [sudo] gem install cocoapods`
	* Press enter

2. Install the artifactory cocoapods plugin gem
	* Open terminal 
	* Type `$ [sudo] gem install cocoapods-art`
	* Press enter

3. Add your artifactory credential to the .netrc file.
	 * Open the `.netrc` file. The `.netrc` file is a hidden file located under the user folder.
     * Create the file if you don't already have one. 
	 * Add the following credentials to the file:
	 ```
     machine soliticsmobilesdk.jfrog.io
     login YOUR_USERNAME
     password YOUR_API_Key
     ``` 
    * Save and close the file.

4. Add artifactory specs repo
    * Open terminal 
    * Type `$ pod repo-art add ios.solitics.mobile.releases "https://soliticsmobilesdk.jfrog.io/artifactory/api/pods/ios.solitics.mobile.releases"`
    * Press enter

5. Add the artifactory plugin to the podfile.
    At the top of your podfile add the following lines:
    ```
    plugin 'cocoapods-art', :sources => [
        'ios.solitics.mobile.releases'
    ]
    ```

6. add the pod to the podfile
    ```
    target ‘YOUR_PROJECT’ do
        …
        pod 'SoliticsSDK'
    end
    ```

7. In the terminal run `pod install`
