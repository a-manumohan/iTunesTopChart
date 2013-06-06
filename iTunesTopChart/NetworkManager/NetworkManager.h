//
//  NetworkManager.h
//  ios_test
//
//  Created by manuMohan on 2/15/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserDelegate.h"
@protocol NetworkManagerDelegate
- (void)requestDataReceived:(id)data;
@end

@interface NetworkManager : NSObject

@property (nonatomic,assign) id<NetworkManagerDelegate> delegate;
//get a singleton object
+ (NetworkManager *)sharedInstance;

- (void)getDataFromUrlString:(NSString *)urlString withParser:(id<ParserDelegate>)parser;
- (void)getDataFromUrlString:(NSString *)urlString;
@end
