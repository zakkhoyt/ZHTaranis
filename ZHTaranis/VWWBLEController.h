//
//  VWWBLEController.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
// BLE libraries available here: http://redbearlab.com/rbl_library


// The interface between iOS and arduino will use this class which uses BLE.


#import <Foundation/Foundation.h>
static NSString *VWWBLEControllerIsNotConnected = @"VWWBLEControllerIsNotConnected";
static NSString *VWWBLEControllerIsConnecting = @"VWWBLEControllerIsConnecting";
static NSString *VWWBLEControllerDidConnect = @"VWWBLEControllerDidConnect";
static NSString *VWWBLEControllerDidDisconnect = @"VWWBLEControllerDidDisconnect";
static NSString *VWWBLEControllerDidUpdateRSSI = @"VWWBLEControllerDidUpdateRSSI";

typedef void (^VWWEmptyBlock)();

@class VWWBLEController;

@interface VWWBLEController : NSObject
+(VWWBLEController*)sharedInstance;
-(void)scanForPeripherals;

-(void)initializeServosWithCompletionBlock:(VWWEmptyBlock)completionBlock;
//-(void)loadCandyWithCompletionBlock:(VWWEmptyBlock)completionBlock;
//-(void)dropCandyInBin:(UInt8)bin completionBlock:(VWWEmptyBlock)completionBlock;
//
//-(void)setLoadPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
//-(void)setInspectPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
//-(void)setDropPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
//-(void)setDispenseMinPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
//-(void)setDispenseMaxPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
//-(void)setDispenseNumChoices:(UInt8)numChoices completionBlock:(VWWEmptyBlock)completionBlock;


@end


































