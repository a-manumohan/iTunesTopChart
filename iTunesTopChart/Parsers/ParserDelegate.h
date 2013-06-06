//
//  ParserDelegate.h
//  ios_test
//
//  Created by manuMohan on 2/15/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>
@required
- (id)parse:(NSString *)data;
@end
