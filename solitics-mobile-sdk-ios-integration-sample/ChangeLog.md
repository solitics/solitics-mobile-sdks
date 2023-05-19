# solitics-sdk-iOS - ChangeLog
 
Solitics SDK is a library that allow it's users to perform Real-Time Events Reporting

## ChangeLog
- 2.2.0.21
    - feature - Change minimum iOS deployment target to 11.0
    - feature - Retry "login" & "emit event" calls automaticly, new retry policy is try every 15 seconds for 3 minutes from the initial call attempt
    - bug fix - promotion HTML is not showing properly
- 2.1.5.20
    - bug fix - analytics event handling for navigation triggers
- 2.1.4.19
    - bug fix - fix null pointer handling 
    - bug fix - fix popup presentation handling for older OS
- 2.1.3.17
    - fix for the colors of the native popup close button
- 2.1.2.14
    - feature - change deeplink navigation handling logic
- 2.1.1.13
    - bug fix - Fixed a null pointer crash in the Dismiss in code use case
- 2.1.0.12
    - bug fix - hex string parsing issue
    - bug fix - changes to websocket reconection handling
    - bug fix - Handling malformed popup messages
    - feature - change UI presentation timing
    - feature - add indication for Solitics UIWindow
    - feature - new api for dismiss in code
- 2.0.1.8
    - change JS handling
    - support in-app navigation
- 2.0.0.7
    - add SoliticsPopupDelagate public interface
    - report to server about popup events
    - heartbeat functionality
    - fixed dismiss button border issue
- 1.0.2.5
    - fix size of close button
