//
//  GameScene.m
//  Theremin3
//
//  Created by Zakk Hoyt on 9/13/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHTouchScene.h"
#import "ZHUtilities.h"

@interface ZHTouchScene ()
@property (nonatomic, strong) SKLabelNode *xLabelNode;
@property (nonatomic, strong) SKLabelNode *yLabelNode;
@property (nonatomic, strong) SKSpriteNode *touchXSprite;
@property (nonatomic, strong) SKSpriteNode *touchYSprite;
@property (nonatomic, strong) SKEmitterNode *sparkEmitterNode;
@property (nonatomic, strong) SKEmitterNode *trailEmitterNode;

@property (nonatomic, strong) SKShapeNode *stickNode;
@end

@implementation ZHTouchScene

-(void)didMoveToView:(SKView *)view {
    [self setupEmitter];
    [self setupLabels];
}


-(void)setupEmitter{
    {
        NSString *messagePath = [[NSBundle mainBundle] pathForResource:@"ZHSparkEmitter" ofType:@"sks"];
        self.sparkEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:messagePath];
        self.sparkEmitterNode.particleBirthRate = 0;
        self.sparkEmitterNode.targetNode = self;
        [self addChild:self.sparkEmitterNode];
    }
    
    {
        NSString *messagePath = [[NSBundle mainBundle] pathForResource:@"ZHTrailEmitter" ofType:@"sks"];
        self.trailEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:messagePath];
        self.trailEmitterNode.particleBirthRate = 0;
        self.trailEmitterNode.targetNode = self;
        [self addChild:self.trailEmitterNode];
    }
}


-(void)setupLabels{
    self.xLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.xLabelNode.text = @"x";
    self.xLabelNode.fontSize = 24;
    self.xLabelNode.color = [UIColor redColor];
    self.xLabelNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
    
    [self addChild:self.xLabelNode];
    
//    self.yLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    self.yLabelNode.text = @"y";
//    self.yLabelNode.fontSize = 24;
//    self.yLabelNode.position = CGPointMake(CGRectGetMidX(self.frame),
//                                           CGRectGetMidY(self.frame) + 40);
//    
//    [self addChild:self.yLabelNode];
}

#pragma mark SKScene

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


#pragma mark UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    self.stickNode = [SKShapeNode shapeNodeWithCircleOfRadius:20];
    
    
    self.sparkEmitterNode.particleBirthRate = 200;
    [self.sparkEmitterNode resetSimulation];
    CGPoint point = [[touches anyObject] locationInNode:self];
    self.sparkEmitterNode.position = point;
    
    self.trailEmitterNode.particleBirthRate = 1000;
    [self.trailEmitterNode resetSimulation];
    self.trailEmitterNode.position = point;
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInNode:self];
    self.sparkEmitterNode.position = point;
    self.trailEmitterNode.position = point;
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInNode:self];
    self.sparkEmitterNode.position = point;
    self.trailEmitterNode.position = point;
    
    self.sparkEmitterNode.particleBirthRate = 0;
    self.trailEmitterNode.particleBirthRate = 0;
}

//-(void)convertTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    for (UITouch *touch in touches) {
//        CGPoint point = [touch locationInNode:self];
//        CGPoint normPoint = [self normalizePoint:point];
// 
//    }
//}
//
#pragma mark Private methods



/*!
 * Converts a point in a view to a 0.0 .. 1.0 ranged point
 * @param point             A typical point in a UIView
 * @return                  CGPoint where x and y range from 0.0 to 1.0
 */

-(CGPoint)normalizePoint:(CGPoint)point{
    CGPoint normPoint = CGPointZero;
    normPoint.x = [ZHUtilities mapInValue:point.x inMinimum:0 inMaximum:self.frame.size.width outMinimum:0.0 outMaximum:1.0];
    normPoint.y = [ZHUtilities mapInValue:point.y inMinimum:0 inMaximum:self.frame.size.height outMinimum:0.0 outMaximum:1.0];
    NSString *posStr = [NSString stringWithFormat:@"x: %.2f,%.2f", normPoint.x, normPoint.y];
    NSLog(@"%@", posStr);
    self.xLabelNode.text = posStr;
    
    
    return normPoint;
}



@end
