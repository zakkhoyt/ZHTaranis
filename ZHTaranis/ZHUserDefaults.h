//
//  ZHUserDefaults.h
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/13/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHUserDefaults : NSObject


+(NSUInteger)maxPPM;
+(void)setMaxPPM:(NSUInteger)maxPPM;

+(NSUInteger)midPPM;
+(void)setMidPPM:(NSUInteger)midPPM;

+(NSUInteger)minPPM;
+(void)setMinPPM:(NSUInteger)minPPM;

@end
