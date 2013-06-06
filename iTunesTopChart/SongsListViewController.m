//
//  SongsListViewController.m
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import "SongsListViewController.h"
#import "CoreDataManager.h"

@interface SongsListViewController (){
    NSArray *topCharts_;
    BOOL loading;
    UIActivityIndicatorView *activityView;
}

@end

@implementation SongsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - topchart loading methods
- (void) fetchTopCharts{
    
}
#pragma mark - networkmanager methods
- (void)requestDataReceived:(id)data{
    TopChartParser *parser = [[TopChartParser alloc] init];
    parser.delegate = self;
    [parser parseTopCharts:data];
}
#pragma mark - TopCharParser methods
-(void)parsedTopCharts:(NSArray *)topCharts{
  
    CoreDataManager *coreDataManager = [CoreDataManager sharedInstance];

    NSArray *songs = topCharts;
    for(NSDictionary *song in songs){
        [coreDataManager storeObject:song intoEntity:@"Song"];
    }
    
    topCharts_ = [[coreDataManager fetchAllDataFromEntity:@"Song"] mutableCopy];
    loading = NO;
    [self.songListTable reloadData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [activityView stopAnimating];
    [activityView removeFromSuperview];
}
-(void)parseError:(NSError *)error{
    
}

#pragma mark - tableview delegate methods
@end
