//
//  SongViewController.h
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong) Song *song;
@property (nonatomic,strong) UIImage *albumImage;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
