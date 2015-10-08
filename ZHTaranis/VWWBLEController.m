//
//  VWWBLEController.m
//
//  ZHTaranis
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
// We will be sending commands to the arduino and back with 3 byte commds:
//          [0]         [1]         [2]
// data[] = [command]   [msb]    [lsb]
//
// So for example if we want to tell arduino to set the throttle to 4
//  UInt8 buf[3] = {kThrottleCommand, 0x00, 0x04};
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
//        if (data[i] == kThrottle){
//            ZH_LOG_INFO(@"Throttle information");
//
//            // Parse msb
//            if (data[i+1] == 0x01){
//            } else {
//            }
//            // Parse lsb
//            if (data[i+2] == 0x01){
//            } else {
//            }
//        }
//    }
//}

#import "VWWBLEController.h"
#import "BLE.h"
#import "ZHDefines.h"



const UInt8 kThrottleCommand = 0x01;
const UInt8 kAileronCommand = 0x02;
const UInt8 kElevatorCommand = 0x03;
const UInt8 kRudderCommand = 0x04;
const UInt8 kAux1Command = 0x05;
const UInt8 kAux2Command = 0x06;
const UInt8 kAux3Command = 0x07;
const UInt8 kAux4Command = 0x08;

const UInt8 kResetCommand = 0xFF;
    
    
    
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
            [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerIsNotConnected object:nil];
            return;
        }
    
    if (_ble.peripherals)
        _ble.peripherals = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerIsConnecting object:nil];

    [_ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)0.5 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
}


-(void)sendInitialize{
    UInt8 buf[] = {kResetCommand, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}


-(void)sendToChannel:(NSUInteger)channel value:(NSUInteger)value{
    NSLog(@"channel: %lu value: %lu", channel, value);
    switch (channel) {
        case kThrottleCommand:
            [self sendValue:value toChannel:kThrottleCommand];
            break;
        case kAileronCommand:
            [self sendValue:value toChannel:kAileronCommand];
            break;
        case kElevatorCommand:
            [self sendValue:value toChannel:kElevatorCommand];
            break;
        case kRudderCommand:
            [self sendValue:value toChannel:kRudderCommand];
            break;
        case kAux1Command:
            [self sendValue:value toChannel:kAux1Command];
            break;
        case kAux2Command:
            [self sendValue:value toChannel:kAux2Command];
            break;
        case kAux3Command:
            [self sendValue:value toChannel:kAux3Command];
            break;
        case kAux4Command:
            [self sendValue:value toChannel:kAux4Command];
            break;
        default:
            break;
    }
}


-(void)sendThrottle:(NSUInteger)throttle{
    [self sendValue:throttle toChannel:kThrottleCommand];
    
}

-(void)sendAileron:(NSUInteger)aileron{
    [self sendValue:aileron toChannel:kAileronCommand];
}

-(void)sendElevator:(NSUInteger)elevator{
    [self sendValue:elevator toChannel:kElevatorCommand];
}

-(void)sendRudder:(NSUInteger)rudder{
    [self sendValue:rudder toChannel:kRudderCommand];
}

-(void)sendAux1:(NSUInteger)aux1{
    [self sendValue:aux1 toChannel:kAux1Command];
}

-(void)sendAux2:(NSUInteger)aux2{
    [self sendValue:aux2 toChannel:kAux2Command];
}

-(void)sendAux3:(NSUInteger)aux3{
    [self sendValue:aux3 toChannel:kAux3Command];
}

-(void)sendAux4:(NSUInteger)aux4{
    [self sendValue:aux4 toChannel:kAux4Command];
}




#pragma mark Private helper
-(void)sendValue:(NSUInteger)value toChannel:(UInt8)channel{
    UInt8 lsb = value & 0xFF;
    UInt8 msb = value >> 8;
    ZH_LOG_DEBUG(@"value: %ld %04x", (unsigned long)value, (unsigned int)value);
    ZH_LOG_DEBUG(@"msb: %04X", (unsigned int)msb);
    ZH_LOG_DEBUG(@"lsb: %04X", (unsigned int)lsb);
    
    UInt8 buf[] = {channel, msb, lsb};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}




#pragma mark Timers


-(void)connectionTimer:(NSTimer *)timer {
    if (_ble.peripherals.count > 0) {
        [_ble connectPeripheral:[_ble.peripherals objectAtIndex:0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerIsConnected object:nil];

    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerIsNotConnected object:nil];
    }
}

-(void)readRSSITimer:(NSTimer *)timer {
    [_ble readRSSI];
}

@end

@implementation VWWBLEController (BLEDelegate)

- (void)bleDidDisconnect {
    ZH_LOG_INFO(@"BLE Disconnected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerDidDisconnect object:nil];
    [self.rssiTimer invalidate];
}

-(void) bleDidUpdateRSSI:(NSNumber *) rssi {
    ZH_LOG_INFO(@"BLE RSSI: %@", rssi.stringValue);
    NSDictionary *object = @{@"rssi": rssi};
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerDidUpdateRSSI object:object];
}


-(void) bleDidConnect {
    ZH_LOG_INFO(@"BLE Connected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWBLEControllerDidConnect object:nil];
    _rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
    
    [self sendInitialize];
}

// When data is comming, this will be called
// We are not sending data from arduino to iOS currently though, so let's leave this empty
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