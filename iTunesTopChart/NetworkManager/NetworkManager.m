//
//  NetworkManager.m
//  ios_test
//
//  Created by manuMohan on 2/15/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import "NetworkManager.h"
static NetworkManager *sharedNetworkManager = nil;
@interface NetworkManager(){
}
@end
@implementation NetworkManager

//get a singleton object
+ (NetworkManager *)sharedInstance{
    if(sharedNetworkManager == nil){
        sharedNetworkManager = [[NetworkManager alloc] init];
    }
    return sharedNetworkManager;
}

#pragma mark - public methods
- (void)getDataFromUrlString:(NSString *)urlString withParser:(id<ParserDelegate>)parser{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData* data,NSError *error){
        id responseObject = [parser parse:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        [self.delegate requestDataReceived:responseObject];
    }];
    
}
- (void)getDataFromUrlString:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData* data,NSError *error){
        [self.delegate requestDataReceived:data];
    }];
    
}
@end
