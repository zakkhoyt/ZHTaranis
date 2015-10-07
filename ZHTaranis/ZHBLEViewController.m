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
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ZHBLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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


- (IBAction)connectButtonAction:(id)sender {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.connectButton.enabled = NO;
    self.hud.dimBackground = YES;
    self.hud.labelText = @"Connecting...";
    [[VWWBLEController sharedInstance] scanForPeripherals];

}




@end
