//
//  ZHSignalManager.m
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/7/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHSignalManager.h"

@interface ZHSignalManager ()
@property (nonatomic) NSUInteger maxValue;
@property (nonatomic) NSUInteger minValue;
@end

@implementation ZHSignalManager
+(ZHSignalManager*)sharedInstance{
    static ZHSignalManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


-(instancetype)init{
    NSAssert(NO, @"Must use sharedInstance");
    return nil;
}

-(instancetype)initSingleton{
    self = [super init];
    if(self){
        self.minValue = 1000;
        self.maxValue = 2000;
    }
    return self;
}

#pragma mark Private methods
-(NSUInteger)clipValue:(NSUInteger)value{
    value = MIN(value, self.maxValue);
    value = MAX(value, self.minValue);
    return value;
}

#pragma mark Public methods

-(void)setThrottle:(NSUInteger)throttle{
    _throttle = [self clipValue:throttle];
}

-(void)setAilerons:(NSUInteger)ailerons{
    _ailerons = [self clipValue:ailerons];
}

-(void)setElevator:(NSUInteger)elevator{
    _elevator = [self clipValue:elevator];
}

-(void)setRoll:(NSUInteger)roll{
    _roll = [self clipValue:roll];
}

@end
