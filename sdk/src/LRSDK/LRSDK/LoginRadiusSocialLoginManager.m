//
//  LoginRadiusSocialLoginManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSocialLoginManager.h"
#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusUtilities.h"

@interface LoginRadiusSocialLoginManager() {}
@property(nonatomic, strong) LoginRadiusTwitterLogin * twitterLogin;
@property(nonatomic, strong) LoginRadiusFacebookLogin * facebookLogin;
@end

@implementation LoginRadiusSocialLoginManager

+ (instancetype)sharedInstance {
	return [LoginRadiusSocialLoginManager instanceWithApplication:nil launchOptions:nil];
}

+ (instancetype)instanceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
	static dispatch_once_t onceToken;
	static LoginRadiusSocialLoginManager *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusSocialLoginManager alloc] initWithApplication: application launchOptions:launchOptions];
	});

	return instance;
}

-(instancetype)initWithApplication:(UIApplication*)application launchOptions:(NSDictionary*)launchOptions {
	self = [super init];
	if (self) {
		_twitterLogin = [LoginRadiusTwitterLogin instanceWithApplication:application launchOptions:launchOptions];
		_facebookLogin = [LoginRadiusFacebookLogin instanceWithApplication:application launchOptions:launchOptions];
		_useNativeLogin = YES;
	}
	return self;
}

#pragma mark Login Methods
-(void)loginWithProvider:(NSString*)provider
			  parameters:(NSDictionary*)params
			inController:(UIViewController*)controller
	   completionHandler:(LRServiceCompletionHandler)handler {

	// TODO Add provider validation for the user
	if( [provider caseInsensitiveCompare:@"twitter"] == NSOrderedSame && self.useNativeLogin) {
		// Use native twitter login
		[_twitterLogin login:handler];
	} else if ([provider caseInsensitiveCompare:@"facebook"] == NSOrderedSame && self.useNativeLogin) {
		// Use native facebook login
		[_facebookLogin loginfromViewController:controller parameters:params handler:handler];
	} else {
		// Use web login
		LoginRadiusWebLoginViewController *webVC = [[LoginRadiusWebLoginViewController alloc] initWithProvider:provider completionHandler:handler];
		UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
		[controller presentViewController:navVC animated:YES completion:nil];
	}
}

- (void)logout {
	// Only facebook native login stores sessions that we have to clear
	[_facebookLogin logout];
}

#pragma mark Application delegate methods
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [[LoginRadiusFacebookLogin sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
@end