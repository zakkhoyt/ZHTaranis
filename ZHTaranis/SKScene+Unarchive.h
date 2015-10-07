//
//  SKScene+Unarchive.h
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/6/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//


@import SpriteKit;

@interface SKScene (Unarchive)
+ (instancetype)unarchiveFromFile:(NSString *)file ;
@end
