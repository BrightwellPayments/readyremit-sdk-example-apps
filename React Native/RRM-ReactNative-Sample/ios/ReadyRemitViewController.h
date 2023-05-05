#import <UIKit/UIkit.h>
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@interface ReadyRemitViewController : UIViewController
@property (nonatomic, assign) id<ReadyRemitDelegate> delegate;
@property (nonatomic, assign) NSString* language;
@property (nonatomic, assign) ReadyRemitEnvironment environment;
@property (nonatomic, strong) ReadyRemitAppearance* appearance;
@end
