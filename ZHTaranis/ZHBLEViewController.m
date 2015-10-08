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
        [self performSegueWithIdentifier:@"SegueConnectToVehicle" sender:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidDisconnect object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if(self.navigationController.viewControllers.count > 0){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        self.outputLabel.text = @"Disconnected!";
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:VWWBLEControllerDidUpdateRSSI object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *rssi = note.object[@"rssi"];
        if(rssi){
            self.rssiLabel.text = [NSString stringWithFormat:@"rssi: %@", rssi.stringValue];
        }
    }];
    self.outputLabel.text = @"";
    self.rssiLabel.text = @"";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)connectButtonAction:(id)sender {
    [[VWWBLEController sharedInstance] scanForPeripherals];
}



@end


