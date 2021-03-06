//
//  NSError+LRError.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (LRError)

+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description failureReason:(NSString *)failureReason;

@end
