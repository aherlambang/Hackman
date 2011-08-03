//
//  GameViewController.h
//  Hackman
//
//  Created by Aditya Herlambang on 8/1/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
{
    UIImageView * gallow;
    NSString * _word;
    NSString * _input;
    NSNumber * _index;
    NSMutableArray * _letter_index;
    int flag;
    int counter;
    
}

- (void) addButtons;
- (void) addGuessSpace;

@property (nonatomic, retain) UIImageView * gallow;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * input;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSMutableArray * letter_index;


extern NSString * const alphabet;

@end
