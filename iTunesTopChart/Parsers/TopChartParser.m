//
//  TopChartParser.m
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import "TopChartParser.h"
@interface TopChartParser(){
    NSXMLParser *parser;
    NSString *currentXmlElement;
    NSMutableArray *topCharts;
    NSMutableDictionary *song;
    BOOL isImage;
    BOOL isCollection;
    BOOL isLink;
}
@end
@implementation TopChartParser
@synthesize delegate;

#pragma mark - public methods
- (void)parseTopCharts:(NSData *)data{
    parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
}
#pragma mark - NSXMLParser methods
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    topCharts = [[NSMutableArray alloc] init];
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"entry"]){
        song = [[NSMutableDictionary alloc] init];
        isImage = NO;
        isCollection = NO;
        isLink = NO;
    }else if([elementName isEqualToString:@"im:image"]){
        NSString *height = [attributeDict objectForKey:@"height"];
        if([height isEqualToString:@"170"]){
            isImage = YES;
        }
    }else if([elementName isEqualToString:@"im:collection"]){
        isCollection = YES;
    }else if([elementName isEqualToString:@"link"]){
        if(isCollection){
            NSString *rel = [attributeDict objectForKey:@"rel"];
            if([rel isEqualToString:@"alternate"]){
                isLink = YES;
            }
        }
    }
    currentXmlElement = @"";
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    currentXmlElement = [currentXmlElement stringByAppendingString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"entry"]){
        [topCharts addObject:song];
    }else if([elementName isEqualToString:@"title"]){
        [song setValue:currentXmlElement forKey:@"title"];
    }else if([elementName isEqualToString:@"im:image"]){
        if(isImage){
            [song setValue:currentXmlElement forKey:@"imageUrl"];
            isImage = NO;
        }
    }else if([elementName isEqualToString:@"link"]){
        if(isLink){
            [song setValue:currentXmlElement forKey:@"link"];
            isLink = NO;
        }
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    if([delegate respondsToSelector:@selector(parsedTopCharts:)]){
        [delegate parsedTopCharts:topCharts];
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if([delegate respondsToSelector:@selector(parseError)]){
        [delegate parseError:parseError];
    }
}
@end
