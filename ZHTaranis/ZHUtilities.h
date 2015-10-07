//
//  Utilities.h
//  SensorTheremin
//
//  Created by Zakk Hoyt on 9/15/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHUtilities : NSObject

// 0 < inputValue < 1.0
// outMinimum < return < outMaximum
+(CGFloat)mapPositiveNormalizedInputValue:(CGFloat)inputValue outMinimum:(CGFloat)outMinimum outMaximum:(CGFloat)outMaximum;

// -1.0 < inputValue < 1.0
// outMinimum < return < outMaximum
+(CGFloat)mapInputNormalizedValue:(CGFloat)inputValue outMinimum:(CGFloat)outMinimum outMaximum:(CGFloat)outMaximum;


+(CGFloat)mapInValue:(CGFloat)inValue
           inMinimum:(CGFloat)inMinimum
           inMaximum:(CGFloat)inMaximum
          outMinimum:(CGFloat)outMinimum
          outMaximum:(CGFloat)outMaximum;
@end
