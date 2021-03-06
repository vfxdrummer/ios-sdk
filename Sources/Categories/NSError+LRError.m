//
//  NSError+LRError.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "NSError+LRError.h"

static NSString * _Nonnull const LoginRadiusDomain = @"com.loginradius";

@implementation NSError (LRError)

+ (NSError *)errorWithCode:(NSInteger)code
			   description:(NSString *)description
			 failureReason:(NSString *)failureReason {
	NSError *err = [NSError errorWithDomain:LoginRadiusDomain
									   code:code
								   userInfo:@{
											  NSLocalizedDescriptionKey: description,
											  NSLocalizedFailureReasonErrorKey: failureReason,
											  }];
	return err;
}


@end
