#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "EncryptionsPlugin.h"
#import <encryptions/encryptions-Swift.h>

@implementation EncryptionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftEncryptionsPlugin registerWithRegistrar:registrar];
}
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
