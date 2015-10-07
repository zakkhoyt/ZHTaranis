//
//  Utilities.m
//  SensorTheremin
//
//  Created by Zakk Hoyt on 9/15/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//
//  Tests
//  CGFloat z = [Utilities mapNormalizedValue:0.5 minimum:30 maximum:330];
//  CGFloat v = [Utilities mapInValue:180 inMinimum:30 inMaximum:330 outMinimum:0.0 outMaximum:2.0];


#import "ZHUtilities.h"

@implementation ZHUtilities

// 0 < inputValue < 1.0
// outMinimum < return < outMaximum
+(CGFloat)mapPositiveNormalizedInputValue:(CGFloat)inputValue outMinimum:(CGFloat)outMinimum outMaximum:(CGFloat)outMaximum{
    return [ZHUtilities mapInValue:inputValue inMinimum:0.0 inMaximum:1.0 outMinimum:outMinimum outMaximum:outMaximum];
}

// -1.0 < inputValue < 1.0
// outMinimum < return < outMaximum
+(CGFloat)mapInputNormalizedValue:(CGFloat)inputValue outMinimum:(CGFloat)outMinimum outMaximum:(CGFloat)outMaximum{
    return [ZHUtilities mapInValue:inputValue inMinimum:-1.0 inMaximum:1.0 outMinimum:outMinimum outMaximum:outMaximum];
}


+(CGFloat)mapInValue:(CGFloat)inValue
           inMinimum:(CGFloat)inMinimum
           inMaximum:(CGFloat)inMaximum
          outMinimum:(CGFloat)outMinimum
          outMaximum:(CGFloat)outMaximum{

    CGFloat inDelta = inMaximum - inMinimum;
    CGFloat iv = inValue - inMinimum;
    CGFloat inNormalized = iv / inDelta;
    
    CGFloat outDelta = outMaximum - outMinimum;
    CGFloat outNormalized = outMinimum + outDelta * inNormalized;
    return outNormalized;
}


@end
