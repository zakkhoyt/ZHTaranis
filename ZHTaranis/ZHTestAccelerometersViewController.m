//
//  ZHTestAccelerometersViewController.m
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/8/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHTestAccelerometersViewController.h"
#import "VWWBLEController.h"

@import CoreMotion;

@interface ZHTestAccelerometersViewController ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *failsafeButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (nonatomic) BOOL sendOutput;
@end

@implementation ZHTestAccelerometersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.motionManager = [[CMMotionManager alloc]init];
    [self startAccelerometers];
    self.navigationController.navigationBarHidden = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidUpdateRSSI object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *rssi = note.object[@"rssi"];
        if(rssi){
            self.rssiLabel.text = [NSString stringWithFormat:@"rssi: %@", rssi.stringValue];
        }
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.motionManager stopAccelerometerUpdates];
}

-(void)startAccelerometers{
    
    for(NSUInteger index = 1; index <= 8; index++){
        [[VWWBLEController sharedInstance] sendToChannel:index value:1500];
    }

    
    
    self.motionManager.accelerometerUpdateInterval = 0.1;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
    
        if(self.startButton.enabled == NO){
            const CGFloat kMin = -0.05;
            const CGFloat kMax = 0.05;
            if(accelerometerData.acceleration.x > kMin && accelerometerData.acceleration.x < kMax &&
               accelerometerData.acceleration.y > kMin && accelerometerData.acceleration.y < kMax &&
               accelerometerData.acceleration.z < 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.startButton.enabled = YES;
                    NSLog(@"Start button enabled");
                });
            }
        } else {
            if(_sendOutput){
                
                const NSUInteger kSensitivity = 1000; // 500
                NSUInteger elevator = 1500 + kSensitivity * accelerometerData.acceleration.y;
                NSUInteger aileron = 1500 + kSensitivity * accelerometerData.acceleration.x;
                [[VWWBLEController sharedInstance] sendThrottle:1000];
                [[VWWBLEController sharedInstance] sendAileron:aileron];
                [[VWWBLEController sharedInstance] sendElevator:elevator];
            }
        }
    }];
}

-(IBAction)startButtonTouchUpInside:(UIButton*)sender{
    [self.startButton setTitle:@"Running" forState:UIControlStateNormal];
    _sendOutput = !_sendOutput;
}


@end
