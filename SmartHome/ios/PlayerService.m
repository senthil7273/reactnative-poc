//
//  DeviceManager.m
//  SmartHome
//
//  Created by Senthil Murugan on 26/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerService.h"



@implementation PlayerService

  RCT_EXPORT_MODULE(PlayerService);


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


- (void)requestSucceedWithResponse:(NSArray<Player *> * _Nonnull)responseData {
  NSError *error = nil;
  NSMutableArray<NSDictionary*> *jsonPlayers = [NSMutableArray array];
  for (Player *response in responseData) {
    [jsonPlayers addObject:[self toJSON: response]];
  }
  NSData *result = [NSJSONSerialization dataWithJSONObject:jsonPlayers
                                              options:NSJSONWritingPrettyPrinted error:&error];
  NSString *jsonString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
  _callResolveBlock(jsonString);
}

- (void)reject: (NSString *)msg {
   _callRejectBlock(msg, 0, 0);
}

-(NSDictionary*) toJSON:(Player*) player {
    return @{
       @"name": player.name,
       @"age": player.age,
       @"salary": player.salary
    };
}

@end
