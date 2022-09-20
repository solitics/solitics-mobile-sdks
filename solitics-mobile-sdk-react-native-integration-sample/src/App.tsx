import * as React from 'react';
import SoliticsSDK, { SoliticsSDKPopupDelegate } from '@solitics/react-native-solitics-sdk';

import {
  SafeAreaView,
  ScrollView
} from 'react-native';
import HomeScreen from './HomeScreen';
import LoginScreen from './LoginScreen';

enum Screen {
  Login, Home
}

interface LogObject {
  logMessage: String
}

const App = () => {

  SoliticsSDK.initSDK()

  const [currentScreen, onScreenChanged] = React.useState(Screen.Login)

  const [presentedLogs, onPresentNewLog] = React.useState("Host app : subscribe on socket event..\n")

  const onSoliticsLogMessageReceived = (message: LogObject) => {
    console.log(message)
    // todo: seems like presentedLogs is passed by value
    onPresentNewLog(presentedLogs + message.logMessage)
  }

  React.useEffect(() => {
    const delegate = new SoliticsSDKPopupDelegate(
      () => { console.log("popup opened callback") },
      () => { console.log("popup closed callback") },
      () => { console.log("popup clicked callback") },
      () => { console.log("popup closed for navigation callback") }
    )
    SoliticsSDK.setSoliticsPopupDelegate(delegate)

    SoliticsSDK.registerSoliticsLogListener(onSoliticsLogMessageReceived)
    SoliticsSDK.currentLoginInfo()
      .then((_loginMetadata) => {
        onScreenChanged(Screen.Home)
      })
      .catch((_e: any) => {
        // no login info, ignore
      })

    // returned function will be called on component unmount 
    return () => {
      SoliticsSDK.removeSoliticsLogListener()
    }
  }, [])

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

  const onLogoutButtonClicked = () => {
    SoliticsSDK.onLogout()
    onScreenChanged(Screen.Login)
  }

  let screenToPresent = currentScreen == Screen.Login
    ? <LoginScreen onLoginButtonClicked={onLoginButtonClicked} />
    : <HomeScreen
      onLogoutButtonClicked={onLogoutButtonClicked}
      onSendEventButtonClicked={(txType: String, txAmount: number, customFields: String) => {
        SoliticsSDK.onEmitEvent(txType, txAmount, customFields)
          .then(() => {
            console.log("event emitted")
          })
          .catch((e: any) => {
            console.error(e)
          })
      }}
      logsToPresent={presentedLogs} />

  return (
    <SafeAreaView>
      <ScrollView contentInsetAdjustmentBehavior="automatic">
        {screenToPresent}
      </ScrollView>
    </SafeAreaView>
  );
}

export default App;