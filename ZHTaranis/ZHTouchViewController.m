//
//  ZHTouchViewController.m
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/6/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHTouchViewController.h"
#import "ZHTouchScene.h"
#import "SKScene+Unarchive.h"


@interface ZHTouchViewController ()
@property (weak, nonatomic) IBOutlet SKView *skView;

@end

@implementation ZHTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSpriteKitScene];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Private methods

-(void)setupSpriteKitScene{
    
    
    
    
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
    
    ZHTouchScene *scene = [ZHTouchScene unarchiveFromFile:@"ZHTouchScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.skView presentScene:scene];
    
}

#pragma mark IBActions

- (IBAction)armButtonTouchUpInside:(id)sender {
}

- (IBAction)disarmButtonTouchUpInside:(id)sender {
}


@end
