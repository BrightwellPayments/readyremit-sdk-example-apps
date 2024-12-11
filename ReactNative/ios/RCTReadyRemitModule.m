#import "RCTReadyRemitModule.h"
#import "AppDelegate.h"
#import "ReadyRemitViewController.h"
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@implementation RCTReadyRemitModule

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"READYREMIT_AUTH_TOKEN_REQUESTED", @"READYREMIT_TRANSFER_SUBMITTED", @"SDK_CLOSED"];
}

RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(setAuthToken: (NSString *)token :(NSString *)errorCode) {
  dispatch_async(dispatch_get_main_queue(), ^{
    self->_authSuccessCallback(token);
  });
}

RCT_EXPORT_METHOD(setTransferId: (NSString *)transferId :(NSString *)errorCode :(NSString *)errorMessage) {
    if (transferId != nil && transferId.length > 0) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self->_transferSuccessCallback(transferId);
      });
  } else {
    dispatch_async(dispatch_get_main_queue(), ^{
      self->_transferFailCallback(errorMessage, errorCode);
    });
  }
}

RCT_EXPORT_METHOD(launch: (NSString *)environment :(NSString *)language :(NSDictionary*)styles) {
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    ReadyRemitViewController *readyRemitViewController = [[ReadyRemitViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readyRemitViewController];
    [readyRemitViewController setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    [navigationController setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    
    if ([environment isEqual:@"PRODUCTION"]) {
      readyRemitViewController.environment = ReadyRemitEnvironmentProduction;
    } else {
      readyRemitViewController.environment = ReadyRemitEnvironmentSandbox;
    }
    
    ReadyRemitAppearance *appearance = [[ReadyRemitAppearance alloc] initWithStyles: styles];
    readyRemitViewController.language = language;
    readyRemitViewController.delegate = self;
    readyRemitViewController.appearance = appearance;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:navigationController animated:YES completion:nil];
  });
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
