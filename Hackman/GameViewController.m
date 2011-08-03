//
//  GameViewController.m
//  Hackman
//
//  Created by Aditya Herlambang on 8/2/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController
@synthesize gallow = _gallow;
@synthesize word = _word;
@synthesize input = _input;
@synthesize index = _index;
@synthesize letter_index = _letter_index;

NSString * const alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) asssignRandomWord
{
    
}

- (void) newGame
{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
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
        UIImageView * space = (UIImageView *) [self.view viewWithTag:0-[index intValue]];
        if ([index intValue] == 0){
             [letter setFrame:CGRectMake(25, 240, 20, 20)];
        } else  
            [letter setFrame:CGRectMake(space.frame.origin.x, 240, 20, 20)];
        [self.view addSubview:letter];
        [letter release];
    }
    
}

- (void) checkValid
{
    if ([self.letter_index count] > 0){
        [self updateLetter];
        if (counter == [[self.word stringByReplacingOccurrencesOfString:@" " withString:@""] length]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"You won"
                                  message: @"Do you want to play again?"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
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
            [alert show];
            [alert release];
        }
    }
    
}

- (IBAction)processInput:(id)sender
{
    UIButton * button = (UIButton *) sender;
    self.input = [NSString stringWithFormat:@"%c", [alphabet characterAtIndex:[button tag]]];
    [self.letter_index removeAllObjects];
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:self.input options:0 error:NULL];
    NSArray* matches = [regex matchesInString:self.word options:0 range:NSMakeRange(0,[self.word length])];
    for(NSTextCheckingResult* i in matches) {
        NSRange range = i.range;
        [self.letter_index addObject:[NSNumber numberWithInt:range.location]];
    }
    [self checkValid];
}

- (void) addButtons
{
    int xOrigin = 15;
    int yOrigin = 265;
    for (int i = 0; i < [alphabet length]; i++){
        if (i % 9 == 0){
            xOrigin = 15;
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
    int xOrigin = 15;
    for (int i = 0; i < [self.word length]; i++){
        UIImageView * space = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button-red"]];
        [space setFrame:CGRectMake(xOrigin, 265, 30, 10)];
        [space setTag:0-i];
        [self.view addSubview:space];
        xOrigin += 35;
        [space release];
    }
}


- (void) viewDidLoad
{
    [super viewDidLoad];
       
    self.word = [NSString stringWithFormat:@"ADITYA"];
    [self newGame];
    
    counter = 0;
    self.index = [NSNumber numberWithInt:1];
    
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
    [_gallow release];
    [_letter_index release];
    [_word release];
    [_input release];
    [_index release];
    [super dealloc];
}


@end
