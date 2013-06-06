//
//  SongsListViewController.h
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopChartParser.h"
#import "NetworkManager.h"

@interface SongsListViewController : UIViewController<NetworkManagerDelegate,TopChartParserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *songListTable;
@end
