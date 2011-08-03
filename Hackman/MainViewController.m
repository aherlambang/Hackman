//
//  MainViewController.m
//  Hackman
//
//  Created by Aditya Herlambang on 7/31/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"
#import "OptionsViewController.h"

@implementation MainViewController
@synthesize play = _play;
@synthesize options = _options;
@synthesize about = _about;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (IBAction) play:(id) sender
{
    GameViewController * game = [[GameViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:game];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:nav animated:YES];
    [game release];
}


- (IBAction) options:(id) sender
{
    OptionsViewController * options = [[OptionsViewController alloc] init];
    [self presentModalViewController:options animated:YES];
}


- (IBAction) about:(id) sender
{
    
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [_play addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [_options addTarget:self action:@selector(options:) forControlEvents:UIControlEventTouchUpInside];
    [_about addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [_play release];
    [_options release];
    [_about release];
    [super dealloc];
}

@end
