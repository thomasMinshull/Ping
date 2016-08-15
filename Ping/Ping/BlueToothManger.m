//
//  BlueToothManager.m
//  Ping
//
//  Created by Jeff Eom on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "BlueToothManager.h"
#import "RecordManager.h"
#import "AppDelegate.h"
#import "CurrentUser.h"
#import "UserManager.h"

@interface BlueToothManager() <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;

@property RecordManager *recordManager;

@property NSMutableArray *cbuuidLists;

@property NSTimer *myTimer;
@property BOOL isScanning;
@property BOOL isTimerValid;

@end

@implementation BlueToothManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recordManager = [RecordManager new];
        self.cbuuidLists = [NSMutableArray array];
        
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        
        [self setUpBluetooth];
        
        self.isScanning = FALSE;
    }
    return self;
}


- (void)setUpBluetooth {
    UserManager *userMan = [[UserManager alloc] init];
    [userMan fetchUsersWthCompletion:^(NSArray *users){
        [self updateCBUUIDList:users];
        [self start];
    }];
    
}

- (void)updateCBUUIDList:(NSArray *)uuids; {
    
    //changing uuid to cbuuid
    for(NSString *aUUIDString in uuids){
        CBUUID *cbuuidString = [CBUUID UUIDWithString:aUUIDString];
        [self.cbuuidLists addObject:cbuuidString];
    }
}

#pragma mark - Start and Stop

-(void)flickSwitch:(NSTimer *)timer{
    if (self.isTimerValid) {
        if (self.isScanning == TRUE) {
            //////
            [self.centralManager stopScan];
            self.isScanning = FALSE;
            ///////
            NSLog(@"switch flicked to false");
            [self.vc logToScreen:@"switch flicked to false"];
        }else{
            //////
            [self scan];
            self.isScanning = TRUE;
            //////
            NSLog(@"switch flicked to true");
            [self.vc logToScreen:@"switch flicked to true"];
        }
    }
}

-(void)start{ // starts listening (central) & transmitting (peripheral)
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:[CurrentUser getCurrentUser].UUID]]}];
    self.isTimerValid = TRUE;
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f
                                                    target: self
                                                  selector:@selector(flickSwitch:)
                                                  userInfo: nil repeats:YES];
    NSLog(@"timer on");
    [self.vc logToScreen:@"timer on"];

}

-(void)stop{ // only stops transmitting (doesn't stop listening?)
    [self.peripheralManager stopAdvertising];
    self.isTimerValid = FALSE;
    NSLog(@"timer off");
    [self.vc logToScreen:@"timer off"];
    
}


#pragma mark - Central Methods


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"central state: %ld", (long)central.state);
    [self.vc logToScreen:[NSString stringWithFormat:@"central state: %ld", (long)central.state]];
    
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    [self scan];
}


- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:[self.cbuuidLists copy]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }
     ];
    
    NSLog(@"Scanning started");
    [self.vc logToScreen:@"Scanning started"];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    [self.vc logToScreen:[NSString stringWithFormat:@"Discovered %@ at %@", peripheral.name, RSSI]];
    
    self.discoveredPeripheral = peripheral;
    
    [self.centralManager connectPeripheral:peripheral options:nil];
    
    /////////////////////////////////////////////////////////////////////////////
    for (CBService *service in peripheral.services) {
        
        NSLog(@"Phone Saving Record!!");
        [self.recordManager storeBlueToothDataByUUID:service.UUID.UUIDString userProximity:[RSSI intValue] andTime:[NSDate date]];
        
        NSLog(@"blueToothData: %@, %d, %@", service.UUID.UUIDString,[RSSI intValue],[NSDate date]);
        [self.vc logToScreen:[NSString stringWithFormat:@"blueToothData: %@, %d, %@", service.UUID.UUIDString,[RSSI intValue],[NSDate date]]];
    }
    ////////////////////////////////////////////////////////////////////////////
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self.vc logToScreen:[NSString stringWithFormat:@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]]];
    
    [self cleanup];
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    [self.vc logToScreen:[NSString stringWithFormat:@"Peripheral Connected"]];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:self.cbuuidLists];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self.vc logToScreen:[NSString stringWithFormat:@"Error discovering services: %@", [error localizedDescription]]];
        [self cleanup];
        return;
    }
    
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Peripheral Disconnected");
    [self.vc logToScreen:[NSString stringWithFormat:@"Peripheral Disconnected"]];
    self.discoveredPeripheral = nil;
    
    [self scan];
}

- (void)cleanup {
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected){
        return;
    }
    
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}


#pragma mark - Peripheral Methods


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    NSLog(@"self.peripheralManager powered on.");
    [self.vc logToScreen:[NSString stringWithFormat:@"self.peripheralManager powered on."]];
    
    CurrentUser *currentUser = [CurrentUser getCurrentUser];
    if (currentUser) {
        CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:currentUser.UUID] primary:YES];
        
        [self.peripheralManager addService:transferService];
    }
    
}

@end
