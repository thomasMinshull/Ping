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
@property NSString *currentUserUUID;
@property RecordManager *recordManager;

@property NSMutableArray *cbuuidLists;
@property BOOL saveSwitch;

@end

@implementation BlueToothManager

+ (instancetype)sharedrecordManager:(NSArray *)uuidList andCurrentUUID:(NSString *)currentUUID {
    static BlueToothManager *sharedrecordManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
//        sharedrecordManager = [[BlueToothManager alloc] initWithUUIDList:@[@"E20A39F4-73F5-4BC4-A12F-17D1AD07A961", @"1C6AAE1E-E4D1-42CB-A642-0856C315A75F", @"F124015B-5AF2-4969-A7A0-38BF2759600F"] andCurrentUUID:@"1C6AAE1E-E4D1-42CB-A642-0856C315A75F"];
        sharedrecordManager = [[BlueToothManager alloc] initWithUUIDList:uuidList andCurrentUUID:currentUUID];
        sharedrecordManager.recordManager = [RecordManager new];
        sharedrecordManager.saveSwitch = NO;
        
//        [sharedrecordManager flickSaveSwitch:self];
    });
    
    [sharedrecordManager start];
    
    return sharedrecordManager;
}

#pragma mark - Start and Stop

-(void)start{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:self.currentUserUUID]]}];
    
    //[self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:app.currentUser.userUUID]]}];  // Keep For later
    [self scan];
}

-(void)stop{
    [self.peripheralManager stopAdvertising];
    
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped, Advertising stopped");
}

#pragma mark - Lifecycle

- (instancetype) initWithUUIDList:(NSArray *)uuidList andCurrentUUID:(NSString *)currentUUID
{
    self = [super init];
    if (self) {
        
//        self.uuidList = @[@"E20A39F4-73F5-4BC4-A12F-17D1AD07A961", @"1C6AAE1E-E4D1-42CB-A642-0856C315A75F", @"F124015B-5AF2-4969-A7A0-38BF2759600F"];
//        self.currentUserUUID = @"F124015B-5AF2-4969-A7A0-38BF2759600F";
       
        self.uuidList = uuidList;
        self.currentUserUUID = currentUUID;
        
        self.fetchedUUIDs = [NSMutableArray array];
        self.fetchedDistances = [NSMutableArray array];
        self.fetchedTimeStamp = [NSMutableArray array];
        
        self.uuids = [NSMutableArray array];
        self.distances = [NSMutableArray array];
        self.timeStamps = [NSMutableArray array];
        
        self.cbuuidLists = [NSMutableArray array];
        
        //chaning uuid to cbuuid
        for(NSString *aUUIDString in self.uuidList){
            CBUUID *cbuuidString = [CBUUID UUIDWithString:aUUIDString];
            [self.cbuuidLists addObject:cbuuidString];
        }
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
       
    }
    return self;
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
    
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:self.currentUserUUID] primary:YES];
    
    [self.peripheralManager addService:transferService];
}

@end
