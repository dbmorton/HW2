//
//  ViewController.h
//  BoxClass
//
//  Created by Andrew Garrahan on 10/27/12.
//  Copyright (c) 2012 Andrew Garrahan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import <AudioToolbox/AudioToolbox.h>	//needed for SystemSoundID

@interface ViewController : UIViewController

@property (strong, nonatomic) UIView * titleView;
@property (strong, nonatomic) UIView * gameView;
@property (strong, nonatomic) UIView * highScoreView;

@property (strong, nonatomic) UIImageView *borgCubeImageView;

//@property (strong, nonatomic) UIView * enterNameView;

//@property (nonatomic) TableViewController *tableViewController;

@end
