#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Override point for customization after application launch.

  [GMSServices provideAPIKey:@"Here API Key"];
    [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
