//
//  SongsListViewController.m
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import "SongsListViewController.h"
#import "CoreDataManager.h"
#import "SongsListTableViewCell.h"
#import "Constants.h"
#import "Song.h"
#import "SongViewController.h"

@interface SongsListViewController (){
    NSArray *topCharts_;
    BOOL loading;
    UIActivityIndicatorView *activityView;
    dispatch_queue_t albumImageQueue;
    NSMutableDictionary *imageCache;
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
    albumImageQueue = dispatch_queue_create("com.ituneschart.imagequeue", NULL);
    imageCache = [[NSMutableDictionary alloc] init];
    self.title = @"Top Songs";
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self fetchTopCharts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - topchart loading methods
- (void) fetchTopCharts{
    loading = YES;
    NetworkManager *manager =[NetworkManager sharedInstance];
    manager.delegate = self;
    [self.view addSubview:activityView];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager getDataFromUrlString:serverUrl];
}
#pragma mark - networkmanager methods
- (void)requestDataReceived:(id)data{
    TopChartParser *parser = [[TopChartParser alloc] init];
    parser.delegate = self;
    [parser parseTopCharts:data];
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
    
}
-(void)parseError:(NSError *)error{
    
}

#pragma mark - UITableView Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(loading){
        return 1;
    }else{
        return [topCharts_ count];
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(loading){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"Loading...";
        return cell;
    }
    SongsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songslisttableviewcell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SongsListTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    Song *song = [topCharts_ objectAtIndex:indexPath.row];
    if([imageCache.allKeys containsObject:song.imageUrl]){
        [[cell albumImageView] setImage:[imageCache valueForKey:song.imageUrl]];
    }else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        dispatch_async(albumImageQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:song.imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [imageCache setValue:[UIImage imageWithData:imageData] forKey:song.imageUrl];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
    [cell.titleLabel setText:[song valueForKey:@"title"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(loading){
        return;
    }
    SongViewController *songViewController = [[SongViewController alloc] initWithNibName:@"SongViewController" bundle:nil];
    Song *song = [topCharts_ objectAtIndex:indexPath.row];
    songViewController.song = song;
    songViewController.albumImage = [imageCache valueForKey:song.imageUrl];
    [self.navigationController pushViewController:songViewController animated:YES];
}

@end
