//
//  CoreDataManager.h
//  ios_test
//
//  Created by manuMohan on 2/15/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject{
    NSManagedObjectContext *context;
}

+(CoreDataManager *)sharedInstance;

- (void)storeObject:(NSDictionary *)Object intoEntity:(NSString *)entity;
- (NSArray *)fetchAllDataFromEntity:(NSString *)entity;
@end
