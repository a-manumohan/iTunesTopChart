//
//  SongViewController.m
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import "SongViewController.h"

@interface SongViewController (){
      dispatch_queue_t albumImageQueue;
}

@end

@implementation SongViewController
@synthesize song;
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
    
    albumImageQueue = dispatch_queue_create("com.ituneschart.singleimagequeue", NULL);
    
    self.title = song.title;
    self.titleLabel.text = song.title;
//    self.imageScrollView.minimumZoomScale = 0.1;
//    self.imageScrollView.maximumZoomScale = 5.0;
    self.imageScrollView.contentSize = CGSizeMake(1000, 1000);
    self.imageScrollView.delegate = self;
    [self loadAndSetImage];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDoubleTapped)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.albumImageView addGestureRecognizer:singleTap];
    [self.albumImageView addGestureRecognizer:doubleTap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup views
- (void)loadAndSetImage{
    if(self.albumImage != nil){
        [self.albumImageView setImage:self.albumImage];
    }else{
        dispatch_async(albumImageQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:song.imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumImage = [UIImage imageWithData:imageData];
                self.albumImageView.image = self.albumImage;
            });
        });
    }
}
#pragma mark - scroll view delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.albumImageView;
}
#pragma mark - tap delegate methods
- (void)imageTapped{
    NSString *link = self.song.link;
    NSRange range = [link rangeOfString:@"://"];
    NSString *trimmedLink = [link substringFromIndex:range.location];
    NSString *itunesLink = [NSString stringWithFormat:@"itms-apps%@",trimmedLink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesLink]];
}
- (void)imageDoubletapped{
    
}
@end
