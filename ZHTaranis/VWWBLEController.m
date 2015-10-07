//
//  VWWBLEController.m

//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWBLEController.h"
#import "BLE.h"
#import "ZHDefines.h"

// We will be sending commands to the arduino and back with 3 byte commds:
//          [0]         [1]         [2]
// data[] = [command]   [param1]    [param2]
//
// So for example if we want to tell arduino to drop a piece of candy in bin 4:
//  UInt8 buf[3] = {kDropCandyCommand, 0x04, 0xXX};
//  NSData *data = [[NSData alloc] initWithBytes:buf length:3];
//  [self.ble write:data];
//
// Likewise, when we send a command from the arudino to iOS parse it like this
//-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
//    ZH_LOG_INFO(@"Length: %d", length);
//    
//    // parse data, all commands are in 3-byte
//    for (int i = 0; i < length; i+=3){
//        ZH_LOG_INFO(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
//        
//        if (data[i] == kCandyWasDroppedCommand){
//            ZH_LOG_INFO(@"Candy was dropped");
//            
//            // Parse param1
//            if (data[i+1] == 0x01){
//            } else {
//            }
//            
//            // Parse param2
//            if (data[i+2] == 0x01){
//            } else {
//            }
//        }
//    }
//}






@interface VWWBLEController () <BLEDelegate>
@property (strong, nonatomic) BLE *ble;
@property (nonatomic, strong) NSTimer *rssiTimer;
@end

@interface VWWBLEController (BLEDelegate) <BLEDelegate>
@end

@implementation VWWBLEController


#pragma mark Public methods

+(VWWBLEController*)sharedInstance{
    static VWWBLEController *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc]initSingleton];
    });
    return instance;
}

- (instancetype)init {
    NSAssert(NO, @"Must use sharedInstance");
    return nil;
}


-(id)initSingleton{
    self = [super init];
    if(self){
        _ble = [[BLE alloc] init];
        [_ble controlSetup];
        _ble.delegate = self;
    }
    return self;
}

// Connect button will call to this
-(void)scanForPeripherals {
    if (_ble.activePeripheral)
        if(_ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[_ble CM] cancelPeripheralConnection:[_ble activePeripheral]];
//            [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerIsNotConnected object:nil];
            return;
        }
    
    if (_ble.peripherals)
        _ble.peripherals = nil;
    
//    [btnConnect setEnabled:false];
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerIsConnecting object:nil];

    [_ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
}

-(void)connectionTimer:(NSTimer *)timer
{
//    [btnConnect setEnabled:true];
//    [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (_ble.peripherals.count > 0)
    {
        [_ble connectPeripheral:[_ble.peripherals objectAtIndex:0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerDidConnect object:nil];

    }
    else
    {
//        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
//        [indConnecting stopAnimating];
        [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerIsNotConnected object:nil];
    }
}

-(void)readRSSITimer:(NSTimer *)timer {
    [_ble readRSSI];
}

@end

@implementation VWWBLEController (BLEDelegate)

- (void)bleDidDisconnect {
    ZH_LOG_INFO(@"->Disconnected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerDidDisconnect object:nil];
    [self.rssiTimer invalidate];
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi {
    ZH_LOG_INFO(@"RSSI: %@", rssi.stringValue);
    NSDictionary *userInfo = @{@"rssi": rssi};
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerDidUpdateRSSI object:userInfo];

}


// When disconnected, this will be called
-(void) bleDidConnect {
    ZH_LOG_INFO(@"->Connected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerDidConnect object:nil];

    // send reset
    UInt8 buf[] = {0x04, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
    
    _rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length {
    ZH_LOG_INFO(@"Length: %d", length);
//
//    // parse data, all commands are in 3-byte
//    for (int i = 0; i < length; i+=3)
//    {
//        NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
//        
//        if (data[i] == 0x0A)
//        {
//            if (data[i+1] == 0x01)
//                swDigitalIn.on = true;
//            else
//                swDigitalIn.on = false;
//        }
//        else if (data[i] == 0x0B)
//        {
//            UInt16 Value;
//            
//            Value = data[i+2] | data[i+1] << 8;
//            lblAnalogIn.text = [NSString stringWithFormat:@"%d", Value];
//        }
//    }
}

@end