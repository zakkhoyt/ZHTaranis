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
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;
@property (weak, nonatomic) IBOutlet UIButton *failsafeButton;

@end

@implementation ZHBLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VWWBLEController sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerIsNotConnected object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Not connected.";
        [self setupConnected:NO];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerIsConnecting object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Connecting!";
        [self setupConnected:NO];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidConnect object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Connected!";
        [self setupConnected:YES];
        [self failsafeButtonTouchUpInside:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidDisconnect object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if(self.navigationController.viewControllers.count > 0){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        self.outputLabel.text = @"Disconnected!";
        [self setupConnected:NO];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidUpdateRSSI object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *rssi = note.object[@"rssi"];
        if(rssi){
            self.rssiLabel.text = rssi.stringValue;
        }
    }];


    self.outputLabel.text = @"";
    self.rssiLabel.text = @"";
    [self setupConnected:NO];
    
}


-(void)setupConnected:(BOOL)connected{
    if(connected){
        self.connectButton.hidden = YES;
        [self.sliders enumerateObjectsUsingBlock:^(UISlider *slider, NSUInteger idx, BOOL * _Nonnull stop) {
            slider.hidden = NO;
        }];
        [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
            label.hidden = NO;
        }];
        self.failsafeButton.hidden = NO;
    } else {
        self.connectButton.hidden = NO;
        [self.sliders enumerateObjectsUsingBlock:^(UISlider *slider, NSUInteger idx, BOOL * _Nonnull stop) {
            slider.hidden = YES;
        }];
        
        [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
            label.hidden = YES;
        }];
        self.failsafeButton.hidden = YES;
    }
}

- (IBAction)connectButtonAction:(id)sender {
    [[VWWBLEController sharedInstance] scanForPeripherals];
    
}

- (IBAction)sliderValueChanged:(UISlider*)sender {
    if(sender.tag >= 1 && sender.tag <= 8){
        [[VWWBLEController sharedInstance]sendToChannel:sender.tag value:sender.value];
    }
}

- (IBAction)failsafeButtonTouchUpInside:(id)sender {
    for(NSUInteger index = 1; index <= 8; index++){
        [[VWWBLEController sharedInstance] sendToChannel:index value:1500];
    }
    [self.sliders enumerateObjectsUsingBlock:^(UISlider *slider, NSUInteger idx, BOOL * _Nonnull stop) {
        slider.value = 1500;
    }];
    
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = @"1500";
    }];
    
}


@end


