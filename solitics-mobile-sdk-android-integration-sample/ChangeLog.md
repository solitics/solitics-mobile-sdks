# solitics-sdk-android - ChangeLog
 
Solitics SDK is a library that allow it's users to perform Real-Time Events Reporting

## ChangeLog
- 3.0.4.46
    - feature - added dynamic data to webhook paramaters
- 3.0.3.45
    - bug fix - logout handling
- 3.0.1.38
    - recompiled for API 33
- 3.0.1.37
    - feature - Change logout action will dismiss current popup, if on screen
    - feature - Add additional internal analytics events
- 3.0.0.33
    - feature - Add additional internal analytics events 
    - feature - Add a push notification handling system
- 2.1.5.19
    - feature - dismiss software keybord if its open when presenting a Solitics popup
- 2.1.5.18
    - bug fix - fix webview handling - now we destroy the webview on the UI thread
- 2.1.4.17
    - feature - Retry "login" & "emit event" calls automaticly, new retry policy is try every 15 seconds for 3 minutes from the initial call attempt
    - bug fix - color parsing - fixed a bug in which the sdk didnt handle non Hex color values properly, now we no  longer crash
    - bug fix - promotion HTML is not showing properly
- 2.1.4.16
    - bug fix - analytics event handling for navigation triggers
- 2.1.3.15
    - bug fix - fixed size of the popup to match device screen
    - bug fix - fixed native close buttons colors

- 2.1.2.14
    - feature - change deeplink navigation handling logic

- 2.1.1.13
    - bug fix - promotion HTML is not showing properly

- 2.1.0.12
    - bug fix - changes to display mechanism 
    - bug fix - changes to websocket reconection handling
    - bug fix - changes to connectivity monitoring 
    - bug fix - WindowLeaked issue fixed
    - feature - new api for dismiss in code
- 2.0.3.10
    - bug fix - solved issue bad popup display when content size was not properly computed
- 2.0.2.9
    - bug fix - solved issue with websocket reconection after losing network access
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
