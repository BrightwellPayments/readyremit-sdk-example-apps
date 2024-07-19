import {
  SafeAreaView,
  StyleSheet,
  NativeModules,
  NativeEventEmitter,
  Pressable,
  Text,
} from "react-native";
import React, { useEffect } from "react";

import tryAuth from "./Auth";

const { ReadyRemitModule } = NativeModules;
const eventEmitter = new NativeEventEmitter(ReadyRemitModule);

export default function App() {
  const readyRemitEnvironment = "SANDBOX"; // Options are 'SANDBOX' or 'PRODUCTION'
  const readyRemitLanguage = "en_US"; // Options are 'en' or 'es_mx'

  const senderId = "<Sender ID>";
  const clientId = "<Client ID>";
  const clientSecret = "<Client Secret>";

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_AUTH_TOKEN_REQUESTED", async () => {
      let auth = await tryAuth(senderId, clientSecret, clientId);
      if (auth["error"] !== null) {
        ReadyRemitModule.setAuthToken(null, auth["error"]);
      }
      if (auth["token"] !== undefined) {
        ReadyRemitModule.setAuthToken(auth["token"], null);
      }
    });

    return function cleanup() {
      eventEmitter.removeAllListeners("READYREMIT_AUTH_TOKEN_REQUESTED");
    };
  }, []);

  useEffect(() => {
    eventEmitter.addListener("SDK_CLOSED", () => {
      console.log("SDK CLOSED");
    });

    return function cleanup() {
      eventEmitter.removeAllListeners("SDK_CLOSED");
    };
  }, []);

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_TRANSFER_SUBMITTED", (request) => {
      ReadyRemitModule.setTransferId("", "", "");
    });

    return function cleanup() {
      eventEmitter.removeAllListeners("READYREMIT_TRANSFER_SUBMITTED");
    };
  }, []);

  return (
    <SafeAreaView>
      <Pressable
        style={styles.pressable}
        onPress={() =>
          ReadyRemitModule.launch(
            readyRemitEnvironment,
            readyRemitLanguage,
            null
          )
        }
      >
        <Text>Start ReadyRemitSDK</Text>
      </Pressable>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  pressable: {
    marginTop: 72,
    marginHorizontal: 24,
  },
});
