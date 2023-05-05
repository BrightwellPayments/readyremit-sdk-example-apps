#import "RCTReadyRemitModule.h"
#import "AppDelegate.h"
#import "ReadyRemitViewController.h"
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@implementation RCTReadyRemitModule

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"READYREMIT_AUTH_TOKEN_REQUESTED", @"READYREMIT_TRANSFER_SUBMITTED", @"SDK_CLOSED"];
}

// Ripped from https://stackoverflow.com/a/12397366
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

RCT_EXPORT_MODULE();

const NSInteger kConditionLockWaiting = 0;
const NSInteger kConditionLockShouldProceed = 1;

- (void) setColorFromPath: (UIColor *)color: (NSDictionary*)styles :(NSString*)path
{
    NSString* hex = [styles valueForKeyPath: path];
    if (hex == nil)
    {
      return;
    }
  
    color = [self colorFromHexString: hex];
}

RCT_EXPORT_METHOD(setAuthToken: (NSString *)token :(NSString *)errorCode) {
  _authSuccessCallback(token);
}

RCT_EXPORT_METHOD(setTransferId: (NSString *)transferId :(NSString *)errorCode :(NSString *)errorMessage) {
    if (transferId != nil && transferId.length > 0) {
        _transferSuccessCallback(transferId);
  } else {
    _transferFailCallback(errorMessage, errorCode);
  }
}

RCT_EXPORT_METHOD(launch: (NSString *)environment :(NSString *)language :(NSDictionary*)styles) {
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    ReadyRemitViewController *readyRemitViewController = [[ReadyRemitViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readyRemitViewController];
    [readyRemitViewController setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    [navigationController setModalPresentationStyle: UIModalPresentationOverCurrentContext];

    ReadyRemitFontScheme.defaultFamily = [styles valueForKeyPath:@"fonts.default.family"];

    ReadyRemitColorScheme *color = [[ReadyRemitColorScheme alloc] init];
    
    if ([styles valueForKeyPath:@"colors"] != nil) {
      color.primaryShade1 = [self colorFromHexString: [styles valueForKeyPath:@"colors.primaryShade1.lightHex"]];
      color.primaryShade2 = [self colorFromHexString: [styles valueForKeyPath:@"colors.primaryShade2.lightHex"]];
      
      color.secondaryShade1 = [self colorFromHexString: [styles valueForKeyPath:@"colors.secondaryShade1.lightHex"]];
      color.secondaryShade2 = [self colorFromHexString: [styles valueForKeyPath:@"colors.secondaryShade2.lightHex"]];
      color.secondaryShade3 = [self colorFromHexString: [styles valueForKeyPath:@"colors.secondaryShade3.lightHex"]];
      
      color.textPrimaryShade1 = [self colorFromHexString: [styles valueForKeyPath:@"colors.textPrimaryShade1.lightHex"]];
      color.textPrimaryShade2 = [self colorFromHexString: [styles valueForKeyPath:@"colors.textPrimaryShade2.lightHex"]];
      color.textPrimaryShade3 = [self colorFromHexString: [styles valueForKeyPath:@"colors.textPrimaryShade3.lightHex"]];
      color.textPrimaryShade4 = [self colorFromHexString: [styles valueForKeyPath:@"colors.textPrimaryShade4.lightHex"]];
      color.textPrimaryShade5 = [self colorFromHexString: [styles valueForKeyPath:@"colors.textPrimaryShade5.lightHex"]];
      
      color.backgroundColorPrimary = [self colorFromHexString: [styles valueForKeyPath:@"colors.backgroundColorPrimary.lightHex"]];
      color.backgroundColorSecondary = [self colorFromHexString: [styles valueForKeyPath:@"colors.backgroundColorSecondary.lightHex"]];
      color.backgroundColorTertiary = [self colorFromHexString: [styles valueForKeyPath:@"colors.backgroundColorTertiary.lightHex"]];
      
      color.error = [self colorFromHexString: [styles valueForKeyPath:@"colors.error.lightHex"]];
      color.success = [self colorFromHexString: [styles valueForKeyPath:@"colors.success.lightHex"]];
      
      color.controlShade1 = [self colorFromHexString: [styles valueForKeyPath:@"colors.controlShade1.lightHex"]];
      color.controlShade2 = [self colorFromHexString: [styles valueForKeyPath:@"colors.controlShade2.lightHex"]];
      
      color.controlAccessoryShade1 = [self colorFromHexString: [styles valueForKeyPath:@"colors.controlAccessoryShade2.lightHex"]];
      color.controlAccessoryShade2 = [self colorFromHexString: [styles valueForKeyPath:@"colors.controlAccessoryShade2.lightHex"]];
    }

    if ([environment isEqual:@"PRODUCTION"]) {
      readyRemitViewController.environment = ReadyRemitEnvironmentProduction;
    } else {
      readyRemitViewController.environment = ReadyRemitEnvironmentSandbox;
    }
    
    ReadyRemitAppearance *appearance = [[ReadyRemitAppearance alloc] initWithColors: color];
    readyRemitViewController.language = language;
    readyRemitViewController.delegate = self;
    readyRemitViewController.appearance = appearance;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:navigationController animated:YES completion:nil];
  });
}

- (NSString *)hexStringFromColor:(UIColor *)color {
  const CGFloat *components = CGColorGetComponents(color.CGColor);
  
  CGFloat r = components[0];
  CGFloat g = components[1];
  CGFloat b = components[2];
  
  return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
          lroundf(r * 255),
          lroundf(g * 255),
          lroundf(b * 255)];
}


- (void) onAuthTokenRequestWithSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(void))failure {
  _authSuccessCallback = [success copy];
  
  
  [self sendEventWithName:@"READYREMIT_AUTH_TOKEN_REQUESTED" body:@{ }];
}

- (void) onSubmitTransferWithTransferRequest:(TransferRequest *)transferRequest success:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSString * _Nonnull, NSString * _Nonnull __strong))failure {
  
  _transferSuccessCallback = [success copy];
  _transferFailCallback = [failure copy];
  [self sendEventWithName:@"READYREMIT_TRANSFER_SUBMITTED" body:[transferRequest toJSON]];
}

- (void) onSDKClose {
     [self sendEventWithName:@"SDK_CLOSED" body:@{ }];
}

@end
