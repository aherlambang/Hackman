//
//  GameState.h
//  Hackman
//
//  Created by Aditya Herlambang on 8/4/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject <NSCoding>
{
    BOOL achieved100points;
    BOOL achieved200points; 
    BOOL achieved300points;
    BOOL achieved400points;
    BOOL solvedAWordBelow5sec;
    BOOL solvedAWordBelow10sec;
}

+ (GameState *) sharedInstance;
- (void) save;

@property (assign) BOOL achieved100points;
@property (assign) BOOL achieved200points;
@property (assign) BOOL achieved300points;
@property (assign) BOOL achieved400points;
@property (assign) BOOL solvedAWordBelow5sec;
@property (assign) BOOL solvedAWordBelow10sec;

@end
