
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
      primaryShade1: { lightHex: "#FF9800", darktHex: "#FF9800" }, //input line, clickable text, primary button
      primaryShade2: { lightHex: "#B16B04", darktHex: "#B16B04" }, //Primary button hover
      secondaryShade1: { lightHex: "#3E3E3E", darktHex: "#3E3E3E" }, //Secondary button hover
      secondaryShade2: { lightHex: "#B7B7B8", darktHex: "#B7B7B8" }, //Primary button disabled
      secondaryShade3: { lightHex: "#232323", darktHex: "#232323" }, //Secondary button border
      textPrimaryShade1: { lightHex: "#3D4045", darktHex: "#3D4045" }, //Common text
      textPrimaryShade2: { lightHex: "#55575A", darktHex: "#55575A" }, //Placeholders
      textPrimaryShade3: { lightHex: "#47494A", darktHex: "#47494A" }, //List items, value texts
      textPrimaryShade4: { lightHex: "#000000", darktHex: "#000000" }, //Titles, secondary button text color
      textPrimaryShade5: { lightHex: "#000000", darktHex: "#000000" }, //Primary button text color
      backgroundColorPrimary: { lightHex: "#F3F0EF", darktHex: "#F3F0EF" }, //Window color
      backgroundColorSecondary: { lightHex: "#FFFFFF", darktHex: "#FFFFFF" }, //Toolbar, cards and bottomsheet
      backgroundColorTertiary: { lightHex: "#FFF3E0", darktHex: "#FFF3E0" }, //Search bar background
      success: { lightHex: "#19AA81", darktHex: "#19AA81" }, //Success messages, success validations, success field values
      error: { lightHex: "#D53F3F", darktHex: "#D53F3F" }, //Error messages, error lines, error fields
      controlShade1: { lightHex: "#898A8C", darktHex: "#898A8C" }, //Disabled inputs
      controlShade2: { lightHex: "#DDDDDD", darktHex: "#DDDDDD" }, //Enabled inputs, search icon color
      controlAccessoryShade1: { lightHex: "#9CA3AF", darktHex: "#9CA3AF" }, //Clear input button icon color
      controlAccessoryShade2: { lightHex: "#1F2937", darktHex: "#1F2937" } //Close button icon color
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
      // Fetch a transferId from your server
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
