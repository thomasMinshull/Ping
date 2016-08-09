//
//  integrationManager.swift
//  Ping
//
//  Created by thomas minshull on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import Foundation


public class IntegrationManager: NSObject {
    public static let sharedIntegrationManager = IntegrationManager()
    
    //MARK: Properties
    public let loginManager:LoginManager = LoginManager()
    public let userManager:UserManager = UserManager()
    public let blueToothManager:BlueToothManager = BlueToothManager()
    
    private override init() {
    }
    
    
}