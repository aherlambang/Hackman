//
//  GameViewController.m
//  Hackman
//
//  Created by Aditya Herlambang on 8/2/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "GameViewController.h"
#import "HackmanIAPHelper.h"
#import "GCHelper.h"
#include <stdlib.h>


#define kHackmanLeaderboard @"com.adityaherlambang.hackman.leaderboard.score"
#define productIdentifier @"com.adityaherlambang.inapphackman.hackmanwords"

@implementation GameViewController
@synthesize gallow = _gallow;
@synthesize word = _word;
@synthesize input = _input;
@synthesize index = _index;
@synthesize letter_index = _letter_index;
@synthesize timer = _timer;
@synthesize timerLabel = _timerLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize word_list = _word_list;
@synthesize hud = _hud;

NSString * const alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) newGame
{
    NSLog(@"NUMBER OF WORDS LEFT %d", [self.word_list count]);
    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
    if ([self.word_list count] > 0){
        counter = 0;
        timerCounter = 0;
        self.index = [NSNumber numberWithInt:1];
    
        //assign random word
        int random = (arc4random() % [self.word_list count]);
        self.word = [self.word_list objectAtIndex:random];
    
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showActivity) userInfo:nil repeats:YES];
    
        //remove previous game view
        NSArray *viewsToRemove = [self.view subviews];
        for (UIView *v in viewsToRemove) {
            if (![v isKindOfClass:[UILabel class]])
                [v removeFromSuperview];
        }
    
        [self addButtons];
        [self addGuessSpace];
    
        self.gallow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hack1.png"]];
        [self.gallow setFrame:CGRectMake(18, 15, 138, 189)];
        [self.view addSubview:self.gallow];
        [self.gallow release];
    
        UIImageView * category = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category.png"]];
        [category setFrame:CGRectMake(180, 29, 120, 11)];
        [self.view addSubview:category];
        [category release];
    } else if (!productPurchased && [self.word_list count] == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Words Exhausted"
                              message: [NSString stringWithFormat:@"You have exhausted the list of words for this category. Buy additional hundreds of words for $.99"]
                              delegate: nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        alert.tag = -14;
        alert.delegate = self;
        [alert show];
        [alert release];

    }
    
}

- (void) menu
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) updateLetter
{
    for (NSNumber * index in self.letter_index){
        counter++;
        UIImageView * letter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.input]]];
        UIImageView * space = (UIImageView *) [self.view viewWithTag:0 - ([index intValue] + 1)];
        [letter setFrame:CGRectMake(space.frame.origin.x, space.frame.origin.y-20, 20, 20)];
        [self.view addSubview:letter];
        [letter release];
        [space removeFromSuperview];
    }
    
}

- (void) updateScore
{
    //need to adjust scoring system
    int wordLength = [[self.word stringByReplacingOccurrencesOfString:@" " withString:@""] length];
    score += (((20/((60 * minutes) + seconds))) * wordLength) * 5;
    if ([self.index intValue] == 1)
        score *= 1.5;
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", score]];
    
    if (score > 0)
        [[GCHelper sharedInstance] reportScore:kLeaderboardHackman score:score];
    
    if (hours == 0 && seconds <= 5){
        [[GCHelper sharedInstance] reportAchievement:kAchieved5seconds percentComplete:100.0];
    } else if (hours == 0 && seconds > 5 && seconds <= 10){
        [[GCHelper sharedInstance] reportAchievement:kAchieved10seconds percentComplete:100.0];
    }   
    
    if (score >= 1000 && score < 2000){
        [[GCHelper sharedInstance] reportAchievement:kAchieved100points percentComplete:100.0];
    } else if (score >= 2000 && score < 3000){
        [[GCHelper sharedInstance] reportAchievement:kAchieved200points percentComplete:100.0];
    } else if (score >= 3000 && score < 4000){
        [[GCHelper sharedInstance] reportAchievement:kAchieved300points percentComplete:100.0];
    } else if (score >= 4000){
        [[GCHelper sharedInstance] reportAchievement:kAchieved400points percentComplete:100.0];
    }

}

- (void) checkValid
{
    if ([self.letter_index count] > 0){
        [self updateLetter];
        if (counter == [[self.word stringByReplacingOccurrencesOfString:@" " withString:@""] length]){
            NSLog(@"Index of object %d", [self.word_list indexOfObject:self.word]);
            [self.word_list removeObject:self.word];
            [self updateScore];
            [self newGame];
        }
    } else {
        if ([self.index intValue] < 7){
            self.index = [NSNumber numberWithInt:[self.index intValue] +1];
            [self.gallow setImage:[UIImage imageNamed:[NSString stringWithFormat:@"hack%d.png", [self.index intValue]]]];
        }else{
            [self.gallow setImage:[UIImage imageNamed:@"hack7.png"]];
            //fill the missing
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"You lose!"
                                  message: [NSString stringWithFormat:@"Word: %@", self.word]
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = -22;
            alert.delegate = self;
            [alert show];
            [alert release];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == -14 && buttonIndex == 1){
        [[HackmanIAPHelper sharedHelper] buyProductIdentifier:productIdentifier];
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Buying more words";
    } else if (alertView.tag == -22)
        [self newGame];
}

- (IBAction)processInput:(id)sender
{
    UIButton * button = (UIButton *) sender;
    if ([button tag] < 27){
        self.input = [NSString stringWithFormat:@"%c", [alphabet characterAtIndex:[button tag]]];
        [self.letter_index removeAllObjects];
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:self.input options:0 error:NULL];
        NSArray* matches = [regex matchesInString:self.word options:0 range:NSMakeRange(0,[self.word length])];
        for(NSTextCheckingResult* i in matches) {
            NSRange range = i.range;
            [self.letter_index addObject:[NSNumber numberWithInt:range.location]];
        }
        [self checkValid];
        [button setTag:100];
    }
}

- (void) addButtons
{
    int xOrigin = 10;
    int yOrigin = 265;
    for (int i = 0; i < [alphabet length]; i++){
        if (i % 9 == 0){
            xOrigin = 10;
            yOrigin += 40;
        }
        UIButton * letter = [[UIButton alloc] init];
        [letter setTag:i];
        [letter setFrame:CGRectMake(xOrigin, yOrigin, 20, 20)];
        [letter addTarget:self action:@selector(processInput:) forControlEvents:UIControlEventTouchUpInside];
        NSString * path = [NSString stringWithFormat:@"%c.png", [alphabet characterAtIndex:i]];
        [letter setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
        [self.view addSubview:letter];
        xOrigin += 35;
        [letter release];
    }
}


- (void) addGuessSpace
{
    NSArray * words = nil;
    float xOrigin = 0.0;
    float yOrigin = 265.0;
    int width = ([self.word length] * 20) + (([self.word length] - 1) * 5.5);
    if ([self.word rangeOfString:@" "].location == NSNotFound)
        xOrigin = (self.view.frame.size.width/2) - (width/2);
    else {  //which means 2 words that doesn't fit into one line
        words = [self.word componentsSeparatedByString:@" "];
        width = ([[words objectAtIndex:0] length] * 20) + (([[words objectAtIndex:0] length] - 1) * 5.5);
        xOrigin = (self.view.frame.size.width/2) - (width/2);
        yOrigin = 240;
    }
    
    for (int i = 1; i <= [self.word length]; i++){
        if ([self.word characterAtIndex:i-1] != ' '){
            UIImageView * space = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button-red"]];
            [space setFrame:CGRectMake(xOrigin, yOrigin, 20, 7)];
            [space setTag:0-i];
            [self.view addSubview:space];
            [space release];
            xOrigin += 25;
        } else { //it's a space, transitioning to the next word that doesn't fit
            xOrigin += 10;
            if (words && [words count] > 1){
                width = ([[words objectAtIndex:1] length] * 20) + (([[words objectAtIndex:1] length] - 1) * 5.5);
                xOrigin = (self.view.frame.size.width/2) - (width/2);
                yOrigin += 35;
            }
        }
           
    }
}


-(void)showActivity;
{
    timerCounter += 1;
    
    hours = timerCounter / 3600 ;
    minutes = timerCounter / 60 - hours * 60; 
    seconds = timerCounter - hours * 3600 - minutes * 60;
    
    [self.timerLabel setText:[NSString stringWithFormat:@"%02d:%02d", minutes, seconds]];
}


- (void)productPurchased:(NSNotification *)notification {
    NSString *pid = (NSString *) notification.object;
    NSLog(@"Purchased: %@", pid);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        [alert release];
    }
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    [super viewWillAppear:animated];

}

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    NSString * plist =  [[NSUserDefaults standardUserDefaults] stringForKey:@"category"];
    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
    if (productPurchased)
        plist = [NSString stringWithFormat:@"%@-paid", plist];
    NSString    *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSData      *plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization                     
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
   
    self.word_list = [temp objectForKey:@"Root"];
    
    //setting up initial view
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 80, 80, 50)];
    [self.scoreLabel setText:@"0"];
    [self.scoreLabel setBackgroundColor:[UIColor clearColor]];
    [self.scoreLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    [self.view addSubview:self.scoreLabel];
    
    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 150, 80, 50)];
    [self.timerLabel setBackgroundColor:[UIColor clearColor]];
    [self.timerLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    [self.view addSubview:self.timerLabel];

    
    score = 0;
    timerCounter = 0;
    [self newGame];
    
    self.letter_index = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UIBarButtonItem * new = [[UIBarButtonItem alloc] initWithTitle:@"New Game" style:UIBarButtonItemStylePlain target:self action:@selector(newGame)];
    self.navigationItem.leftBarButtonItem  = new;
    [new release];
    
    UIBarButtonItem * menu = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menu)];
    self.navigationItem.rightBarButtonItem = menu;
    [menu release];
}

- (void) dealloc
{
    [_word_list release];
    [_scoreLabel release];
    [_timerLabel release];
    [_timer release];
    [_gallow release];
    [_letter_index release];
    [_word release];
    [_input release];
    [_index release];
    [super dealloc];
}


@end
