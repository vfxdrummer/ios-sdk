//
//  LoginRadiusRegistrationManager.m
//  LR-iOS-SDK-Sample
//
//  Created by Raviteja Ghanta on 19/04/16.
//  Copyright © 2016 LR. All rights reserved.
//

#import "LoginRadiusRegistrationManager.h"
#import "LoginRadiusRaaSViewController.h"

@implementation LoginRadiusRegistrationManager

+ (instancetype)sharedInstance {
	return [LoginRadiusRegistrationManager instanceWithApplication:nil launchOptions:nil];
}

+ (instancetype)instanceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
	static dispatch_once_t onceToken;
	static LoginRadiusRegistrationManager *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusRegistrationManager alloc] initWithApplication: application launchOptions:launchOptions];
	});

	return instance;
}

- (instancetype)initWithApplication:(UIApplication*)application launchOptions:(NSDictionary*)launchOptions {
	self = [super init];
	if (self) {}
	return self;
}

- (void) registrationWithAction:(NSString*) action inController:(UIViewController*)controller completionHandler:(loginResult)handler {
	LoginRadiusRaaSViewController *webVC = [[LoginRadiusRaaSViewController alloc] initWithAction:action];
	[controller presentViewController:webVC animated:YES completion:nil];
}
@end
