#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^loginResult)(NSMutableDictionary *user, NSError *error);
typedef void (^responseHandler)(NSDictionary *data, NSError *error);

@interface LoginRadiusSDK : NSObject

// Initilization
+ (void)instanceWithAPIKey:(NSString *)apiKey
				  siteName:(NSString *)siteName
			   application:(UIApplication *)application
			 launchOptions:(NSDictionary *)launchOptions;

+ (instancetype)sharedInstance;

// Application Delegate methods
- (BOOL)application:(UIApplication *)application
		   openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
		annotation:(id)annotation;

- (void)applicationDidBecomeActive:(UIApplication *)application;

// Social login
+ (void) socialLoginWithProvider:(NSString*)provider
					inController:(UIViewController*)controller
			   completionHandler:(loginResult)handler;

// User Registration
+ (void) userRegistrationWithAction:(NSString*) action
					   inController:(UIViewController*)controller
				  completionHandler:(loginResult)handler;

+ (void) logout;

+ (NSString*) apiKey;
+ (NSString*) siteName;

@end
