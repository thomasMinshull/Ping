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

@interface BlueToothManager() <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBCentralManager          *centralManager;
@property (strong, nonatomic) CBPeripheral              *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData             *data;

@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;

@property NSMutableArray *fetchedUUIDs;
@property NSMutableArray *fetchedDistances;
@property NSMutableArray *fetchedTimeStamp;

@property NSMutableArray *uuids;
@property NSMutableArray *distances;
@property NSMutableArray *timeStamps;

@property NSArray *uuidList;
@property RecordManager *recordManager;

@property NSMutableArray *cbuuidLists;
@property BOOL saveSwitch;

@end

@implementation BlueToothManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recordManager = [RecordManager new];
        self.saveSwitch = NO;
        
        self.fetchedUUIDs = [NSMutableArray array];
        self.fetchedDistances = [NSMutableArray array];
        self.fetchedTimeStamp = [NSMutableArray array];
        
        self.uuids = [NSMutableArray array];
        self.distances = [NSMutableArray array];
        self.timeStamps = [NSMutableArray array];
        
        self.cbuuidLists = [NSMutableArray array];
        
//        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//        
//        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)setUUIDList:(NSArray *)uuidList andCurrentUUID:(NSString *)currentUUID {
    self.uuidList = uuidList;
    
    //changing uuid to cbuuid
    for(NSString *aUUIDString in self.uuidList){
        CBUUID *cbuuidString = [CBUUID UUIDWithString:aUUIDString];
        [self.cbuuidLists addObject:cbuuidString];
    }
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - Start and Stop

-(void)start{
    CurrentUser *currentUser = [CurrentUser getCurrentUser];
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:currentUser.UUID]]}];
    
    [self scan];
}

-(void)stop{
    [self.peripheralManager stopAdvertising];
    
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped, Advertising stopped");
}


#pragma mark - Central Methods


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"central state: %ld", (long)central.state);
    
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    [self scan];
}


- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:[self.cbuuidLists copy]
     options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }
     ];
    
    NSLog(@"Scanning started");
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    [self.fetchedDistances addObject:[NSNumber numberWithInteger:[RSSI integerValue]]];
    
    NSDate *localDate = [NSDate date];
    
    [self.fetchedTimeStamp addObject:localDate];
    
    self.discoveredPeripheral = peripheral;
    
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:self.cbuuidLists];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    /////////////////////////////////////////////////////////////////////////////
    for (CBService *service in peripheral.services) {
        
        [self.fetchedUUIDs addObject:service.UUID.UUIDString];
        
        [self.uuids addObject:[self.fetchedUUIDs lastObject]];
        [self.distances addObject: [self.fetchedDistances lastObject]];
        [self.timeStamps addObject:[self.fetchedTimeStamp lastObject]];

      //  if (self.saveSwitch == true) {
            NSNumber *proximity = [self.fetchedDistances lastObject];
            [self.recordManager storeBlueToothDataByUUID:[self.fetchedUUIDs lastObject] userProximity:[proximity intValue] andTime:[self.fetchedTimeStamp lastObject]];
      //  }


        
//
        
//        [self.recordManager storeBlueToothDataByUUID:[self.fetchedUUIDs lastObject] userProximity:proximity.integerValue andTime:[self.fetchedTimeStamp lastObject]];
        
        NSLog(@"blueToothData: %@, %@, %@", [self.fetchedUUIDs lastObject],[self.fetchedDistances lastObject],[self.fetchedTimeStamp lastObject]);
    }
    ////////////////////////////////////////////////////////////////////////////
}

-(void)flickSaveSwitch:(id)sender {
    // first call turns it on
    if (self.saveSwitch) {
        self.saveSwitch = NO;
        NSLog(@"Switch off");
    } else {
        self.saveSwitch = YES;
        NSLog(@"switch On");
    }
//    // will turn off in 0.1
//    [NSTimer scheduledTimerWithTimeInterval:0.1
//                                     target:self
//                                   selector:@selector(flickSaveSwitch:)
//                                   userInfo:nil
//                                    repeats:YES];
    
    // repeate every 5 sec
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(flickSaveSwitch:)
                                   userInfo:nil
                                    repeats:YES];
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    
    [self scan];
}

- (void)cleanup
{
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
    
    CurrentUser *currentUser = [CurrentUser getCurrentUser];
    if (currentUser) {
        CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:currentUser.UUID] primary:YES];
        
        [self.peripheralManager addService:transferService];
    }
    
}

@end
