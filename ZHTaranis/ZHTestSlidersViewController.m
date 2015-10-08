//
//  ZHTestSlidersViewController.m
//  ZHTaranis
//
//  Created by Zakk Hoyt on 10/8/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHTestSlidersViewController.h"
#import "VWWBLEController.h"
#import "MBProgressHUD.h"
#import "ZHDefines.h"


@interface ZHTestSlidersViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *valueLabels;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *valueSliders;
@property (weak, nonatomic) IBOutlet UIButton *failsafeButton;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@end

@implementation ZHTestSlidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidUpdateRSSI object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *rssi = note.object[@"rssi"];
        if(rssi){
            self.rssiLabel.text = [NSString stringWithFormat:@"rssi: %@", rssi.stringValue];
        }
    }];

    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)sliderValueChanged:(UISlider*)sender {
    if(sender.tag >= 1 && sender.tag <= 8){
        [[VWWBLEController sharedInstance]sendToChannel:sender.tag value:sender.value];
    }
}

- (IBAction)failsafeButtonTouchUpInside:(id)sender {
    for(NSUInteger index = 1; index <= 8; index++){
        [[VWWBLEController sharedInstance] sendToChannel:index value:1500];
    }
    [self.valueSliders enumerateObjectsUsingBlock:^(UISlider *slider, NSUInteger idx, BOOL * _Nonnull stop) {
        slider.value = 1500;
    }];
    
    [self.valueLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = @"1500";
    }];
    
}


@end
