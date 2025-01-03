
import React, { useEffect } from 'react';
import { Button, SafeAreaView } from 'react-native';
import { NativeModules, NativeEventEmitter } from 'react-native'
import onAuth from './api/Auth';
import { readyRemitStyles } from './theme/theme';

const App = () => {
  const { ReadyRemitModule } = NativeModules;
  const eventEmitter = new NativeEventEmitter(ReadyRemitModule);
  const readyRemitEnvironment = 'SANDBOX'; // Options are 'SANDBOX' or 'PRODUCTION'
  const readyRemitLanguage = 'en_US'; // Options are 'en' or 'es_mx'

  const senderId = "<Sender ID>";
  const clientId = "<CLient ID>";
  const clientSecret = "<CLient Secret>";

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
      <Button title='Start SDK' onPress={() => ReadyRemitModule.launch(readyRemitEnvironment, readyRemitLanguage, readyRemitStyles)}>Start ReadyRemitSDK</Button>
    </SafeAreaView>
  );
};

export default App;
