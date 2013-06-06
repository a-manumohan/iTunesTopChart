//
//  TopChartParser.h
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TopChartParserDelegate <NSObject>

-(void)parsedTopCharts:(NSArray *)topCharts;
@optional
-(void)parseError:(NSError *)error;

@end
@interface TopChartParser : NSObject<NSXMLParserDelegate>

@property (nonatomic,assign) id<TopChartParserDelegate>delegate;

-(void)parseTopCharts:(NSData *)data;
@end
