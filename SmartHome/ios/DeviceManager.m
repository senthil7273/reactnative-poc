//
//  DeviceManager.m
//  SmartHome
//
//  Created by Senthil Murugan on 26/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceManager.h"



@implementation DeviceManager

  RCT_EXPORT_MODULE(DeviceManager);


RCT_REMAP_METHOD(getData,
                  params:(NSDictionary *)params
                   findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                   rejecter:(RCTPromiseRejectBlock)reject) {
    //assigning resolve & reject callbacks
    NSLog(@"Urls is %@",[params description]);
    _callResolveBlock = resolve;
    _callRejectBlock = reject;

    RCTLogInfo(@"hitting findevents");
    
  
  if (params == nil) {
    [self reject:@"No params found"];
    return;
  }
  
  CommunicationManager *commMgr = [[CommunicationManager alloc] init];
  commMgr.responseHandler = self;
   [commMgr getDataWithURL: params auth: @"" withDescription: @"players"];
}
  

- (void)requestFailedWithStatusCode:(NSInteger)statusCode description:(NSString * _Nonnull)description {
  NSLog(@"Failed---");
  [self reject: description];
  
}

- (void)requestSucceedWithResponse:(NSData * _Nonnull)responseData {
  NSLog(@"succeed ----");
  NSError *error = nil;
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
  _callResolveBlock(json);
}

- (void)reject: (NSString *)msg {
   _callRejectBlock(msg, 0, 0);
}


@end
