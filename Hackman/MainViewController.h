//
//  MainViewController.h
//  Hackman
//
//  Created by Aditya Herlambang on 7/31/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    UIButton * _play;
    UIButton * _options;
    UIButton * _about;
}

@property (nonatomic, retain) IBOutlet UIButton * play;
@property (nonatomic, retain) IBOutlet UIButton * options;
@property (nonatomic, retain) IBOutlet UIButton * about;
@end
