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
#import "ZHUserDefaults.h"

const NSUInteger kValueLabelTag = 200;

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

#pragma mark Private methods

#pragma mark IBActions

- (IBAction)sliderValueChanged:(UISlider*)sender {
    if(sender.tag >= 1 && sender.tag <= 8){
        [[VWWBLEController sharedInstance]sendToChannel:sender.tag value:sender.value];
        
        UILabel *valueLabel = [self.view viewWithTag:kValueLabelTag + sender.tag];
        valueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)sender.value];
    }
}

- (IBAction)failsafeButtonTouchUpInside:(id)sender {
    for(NSUInteger index = 1; index <= 8; index++){
        [[VWWBLEController sharedInstance] sendToChannel:index value:[ZHUserDefaults midPPM]];
    }
    
    [self.valueSliders enumerateObjectsUsingBlock:^(UISlider *slider, NSUInteger idx, BOOL * _Nonnull stop) {
        slider.value = [ZHUserDefaults midPPM];
    }];
    
    [self.valueLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[ZHUserDefaults midPPM]];
    }];
}


@end
