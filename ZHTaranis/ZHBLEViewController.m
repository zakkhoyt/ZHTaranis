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

@interface ZHBLEViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ZHBLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerIsNotConnected object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Not connected.";
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerIsConnecting object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Connecting!";
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidConnect object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.outputLabel.text = @"Connected!";
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

    self.outputLabel.text = @"";
    self.rssiLabel.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)connectButtonAction:(id)sender {
//    self.connectButton.enabled = NO;
    [[VWWBLEController sharedInstance] scanForPeripherals];
    
}




@end


