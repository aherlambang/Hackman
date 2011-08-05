//
//  OptionsViewController.h
//  Hackman
//
//  Created by Aditya Herlambang on 8/2/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MBProgressHUD.h"

@interface OptionsViewController : UITableViewController <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    MBProgressHUD *_hud;
    UISwitch * _sound;
    int checkedRow;
}

@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) UISwitch * sound;

@end
