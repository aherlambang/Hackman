//
//  GameViewController.h
//  Hackman
//
//  Created by Aditya Herlambang on 8/1/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface GameViewController : UIViewController <UIAlertViewDelegate>
{
    NSTimer * _timer;
    UILabel * _timerLabel;
    
    UILabel * _scoreLabel;
    
    UIImageView * gallow;
    NSString * _word;
    NSString * _input;
    NSNumber * _index;
    NSMutableArray * _letter_index;
    NSMutableArray * _word_list;
 
    int counter;
    int timerCounter;
    int score;
    
    //used for timer
    int hours;
    int minutes;
    int seconds;
  
     MBProgressHUD *_hud;
}

- (void) addButtons;
- (void) addGuessSpace;

@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) NSMutableArray * word_list;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, retain) UILabel * scoreLabel;
@property (nonatomic, retain) UILabel * timerLabel;
@property (nonatomic, retain) UIImageView * gallow;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * input;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSMutableArray * letter_index;


extern NSString * const alphabet;

@end
