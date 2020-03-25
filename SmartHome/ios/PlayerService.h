//
//  DeviceManager.h
//  SmartHome
//
//  Created by Senthil Murugan on 26/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#ifndef DeviceManager_h
#define DeviceManager_h


#endif /* DeviceManager_h */

#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>
#import "SmartHome-Bridging-Header.h"
#import "SmartHome-Swift.h"
//framework havnt worked , so commented it
//#import <CustomNetwork/CustomNetwork-Swift.h>
@interface PlayerService: NSObject<RCTBridgeModule, ResponseHandler>
  @property (nonatomic, copy) RCTPromiseResolveBlock callResolveBlock;
  @property (nonatomic, copy) RCTPromiseRejectBlock callRejectBlock;

  -(void)reject: (NSString *) msg;

@end
