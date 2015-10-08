//
//  ZHBLEViewController.m
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/7/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHBLEViewController.h"
#import "VWWBLEController.h"
#import "MBProgressHUD.h"
#import "ZHDefines.h"

@interface ZHBLEViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UISlider *throttleSlider;

@end

@implementation ZHBLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VWWBLEController sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerIsNotConnected object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Not connected.";
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerIsConnecting object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Connecting!";
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidConnect object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Connected!";
        self.throttleSlider.hidden = NO;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidDisconnect object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if(self.navigationController.viewControllers.count > 0){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        self.outputLabel.text = @"Disconnected!";
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidUpdateRSSI object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *rssi = note.userInfo[@"rssi"];
        if(rssi){
            self.rssiLabel.text = rssi.stringValue;
        }
    }];

//    self.throttleSlider.hidden = YES;
    self.throttleSlider.minimumValue = 1000;
    self.throttleSlider.maximumValue = 2000;
    self.outputLabel.text = @"";
    self.rssiLabel.text = @"";
}



- (IBAction)connectButtonAction:(id)sender {
    [[VWWBLEController sharedInstance] scanForPeripherals];
    
}

- (IBAction)throttleSliderValueChanged:(UISlider*)sender {
    NSUInteger throttle = sender.value;
    
    UInt8 lsb = throttle % 0xFF;
    UInt8 msb = throttle >> 8;
    ZH_LOG_DEBUG(@"throttle: %lu", (unsigned long)throttle);
    ZH_LOG_DEBUG(@"msb: %lu", (unsigned long)msb);
    ZH_LOG_DEBUG(@"lsb: %lu", (unsigned long)lsb);

}



@end


