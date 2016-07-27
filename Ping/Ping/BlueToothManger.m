//
//  BlueToothManager.m
//  Ping
//
//  Created by Jeff Eom on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "BlueToothManager.h"

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

@end

@implementation BlueToothManager

#pragma mark - Start and Stop

-(void)start{
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // Start up the CBPeripheralManager
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:self.currentUserUUID]]}];
}

-(void)stop{
    [self.peripheralManager stopAdvertising];
}


#pragma mark - View Lifecycle

- (instancetype)initWithUUIDList:(NSArray *)uuidList andCurrentUUID:(NSString *)currentUUID
{
    self = [super init];
    if (self) {
        
        self.uuidList = uuidList;
        self.currentUserUUID = currentUUID;
        
        self.fetchedUUIDs = [NSMutableArray array];
        self.fetchedDistances = [NSMutableArray array];
        self.fetchedTimeStamp = [NSMutableArray array];
        
        self.uuids = [NSMutableArray array];
        self.distances = [NSMutableArray array];
        self.timeStamps = [NSMutableArray array];
        
        self.bluetoothData = [NSMutableArray array];
        
        [self start];
        
    }
    return self;
}

- (void)sendInBluetoothData{
    self.bluetoothData = [@[self.uuids, self.distances, self.timeStamps] mutableCopy];
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
    [
     self.centralManager
     scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID], [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID2], [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID3]]
     options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }
     ];
    
    NSLog(@"Scanning started");
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    [self.fetchedDistances addObject:[NSString stringWithFormat:@"%ld", (long)RSSI.integerValue]];
    
    NSString *localDate = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    
    [self.fetchedTimeStamp addObject:localDate];
    
    
    if (self.discoveredPeripheral != peripheral) {
        
        self.discoveredPeripheral = peripheral;
        
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    // Stop scanning
    // [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;                 // will this be a problem with multiple devices
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID], [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID2], [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID3]]];
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
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
        
        [self.fetchedUUIDs addObject:service.UUID.UUIDString];
        
        [self.uuids addObject:[self.fetchedUUIDs lastObject]];
        [self.distances addObject: [self.fetchedDistances lastObject]];
        [self.timeStamps addObject:[self.fetchedTimeStamp lastObject]];
        
        if (self.uuids.count > 1){
            for(int i =0 ; i < self.uuids.count; i++){
                NSLog(@"blueToothData: %@, %ld, %@", self.timeStamps[i], (long)self.distances[i], self.uuids[i]);
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    
    // We're disconnected, so start scanning again
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
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    NSLog(@"self.peripheralManager powered on.");
    
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                       primary:YES];
    
    [self.peripheralManager addService:transferService];
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central subscribed to characteristic");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central unsubscribed from characteristic");
}

@end
