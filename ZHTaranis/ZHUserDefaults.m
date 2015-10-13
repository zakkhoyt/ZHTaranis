//
//  ZHUserDefaults.m
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/13/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUserDefaults.h"

@implementation ZHUserDefaults

const NSUInteger kDefaultMaxPPM = 2000;
static NSString *ZHMaxPPM = @"ZHMaxPPM";
+(NSUInteger)maxPPM{
    NSNumber *ppmNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZHMaxPPM"];
    if(ppmNumber){
        return ppmNumber.unsignedIntegerValue;
    } else {
        return kDefaultMaxPPM;
    }
}
+(void)setMaxPPM:(NSUInteger)maxPPM{
    [[NSUserDefaults standardUserDefaults] setObject:@(maxPPM) forKey:ZHMaxPPM];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

const NSUInteger kDefaultMidPPM = 1500;
static NSString *ZHMidPPM = @"ZHMidPPM";
+(NSUInteger)midPPM{
    NSNumber *ppmNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZHMidPPM"];
    if(ppmNumber){
        return ppmNumber.unsignedIntegerValue;
    } else {
        return kDefaultMidPPM;
    }
}
+(void)setMidPPM:(NSUInteger)midPPM{
    [[NSUserDefaults standardUserDefaults] setObject:@(midPPM) forKey:ZHMidPPM];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

const NSUInteger kDefaultMinPPM = 1000;
static NSString *ZHMinPPM = @"ZHMinPPM";
+(NSUInteger)minPPM{
    NSNumber *ppmNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZHMinPPM"];
    if(ppmNumber){
        return ppmNumber.unsignedIntegerValue;
    } else {
        return kDefaultMinPPM;
    }
}
+(void)setMinPPM:(NSUInteger)minPPM{
    [[NSUserDefaults standardUserDefaults] setObject:@(minPPM) forKey:ZHMinPPM];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
