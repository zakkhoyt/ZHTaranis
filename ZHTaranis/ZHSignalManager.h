//
//  ZHSignalManager.h
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/7/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHSignalManager : NSObject
+(ZHSignalManager*)sharedInstance;

@property (nonatomic) NSUInteger throttle;
@property (nonatomic) NSUInteger ailerons;
@property (nonatomic) NSUInteger elevator;
@property (nonatomic) NSUInteger roll;



@end
