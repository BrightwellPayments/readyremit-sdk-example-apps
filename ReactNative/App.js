
import React, { useEffect } from 'react';
import { Button, SafeAreaView } from 'react-native';
import { NativeModules, NativeEventEmitter } from 'react-native'
import onAuth from './api/Auth';

const App = () => {
  const { ReadyRemitModule } = NativeModules;
  const eventEmitter = new NativeEventEmitter(ReadyRemitModule);
  const readyRemitEnvironment = 'SANDBOX'; // Options are 'SANDBOX' or 'PRODUCTION'
  const readyRemitLanguage = 'en'; // Options are 'en' or 'es_mx'

  const senderId = "<Your Sender ID>";
  const clientId = "<Your Client ID>";
  const clientSecret = "<Your Client Secret>";

  const styles = {
    fonts: {
      default: { family: 'luminari' }
    },
    colors: {
      background: { lightHex: "#F3F4F6", darkHex: "#111111" },
      foreground: { lightHex: "#FFFFFF", darkHex: "#1F1F1F" },
      buttonText: { lightHex: "#FFFFFF", darkHex: "#FFFFFF" },
      danger: { lightHex: "#AA220F", darkHex: "#AA220F" },
      dangerLight: { lightHex: "#ECDFDF", darkHex: "#201311" },
      success:  { lightHex: "#008761", darkHex: "#008761" },
      divider: { lightHex: "#E2E2E2", darkHex: "#313131" },
      inputLine:  { lightHex: "#858585", darkHex: "#505050" },
      icon: { lightHex: "#444444", darkHex: "#7E7E7E" },
      primary: { lightHex: "#2563EB", darkHex: "#558CF4" },
      primaryLight: { lightHex: "#6B8DD6", darkHex: "#83ACF7" },
      text: { lightHex: "#0E0F0C", darkHex: "#E3E3E3" },
      textSecondary: { lightHex: "#454545", darkHex: "#B0B0B0" }
    }
  }

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_AUTH_TOKEN_REQUESTED", async () => {
      let auth = await onAuth(senderId, clientSecret, clientId);
      if (auth["error"] !== null) {
        ReadyRemitModule.setAuthToken(null, auth["error"]);
      }
      if (auth["token"] !== undefined) {
        ReadyRemitModule.setAuthToken(auth["token"], null);
      }
    });

    return function cleanup() {
      eventEmitter.removeAllListeners("READYREMIT_AUTH_TOKEN_REQUESTED");
    }
  }, []);

  useEffect(() => {
    eventEmitter.addListener("SDK_CLOSED", () => {
      console.log("SDK CLOSED");
    })

    return function cleanup() {
      eventEmitter.removeAllListeners("SDK_CLOSED");
    }
  }, []);

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_TRANSFER_SUBMITTED", (request) => {
      ReadyRemitModule.setTransferId("", "", "");
    })

    return function cleanup() {
      eventEmitter.removeAllListeners("READYREMIT_TRANSFER_SUBMITTED");
    }
  }, []);

  return (
    <SafeAreaView>
      <Button title='Start SDK' onPress={() => ReadyRemitModule.launch(readyRemitEnvironment, readyRemitLanguage, styles)}>Start ReadyRemitSDK</Button>
    </SafeAreaView>
  );
};

export default App;
