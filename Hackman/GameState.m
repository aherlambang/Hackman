//
//  GameState.m
//  Hackman
//
//  Created by Aditya Herlambang on 8/4/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "GameState.h"
#import "GCDatabase.h"

@implementation GameState
@synthesize achieved100points;
@synthesize achieved200points;
@synthesize achieved300points;
@synthesize achieved400points;
@synthesize solvedAWordBelow5sec;
@synthesize solvedAWordBelow10sec;

static GameState* sharedInstance = nil;

+(GameState *) sharedInstance
{
    @synchronized([GameState class]){
        if (!sharedInstance){
            sharedInstance = [loadData(@"GameState") retain];
            if (!sharedInstance){
                [[self alloc] init];
            }
        }
        return sharedInstance;
    }
    return nil;
}

+(id) alloc
{
    @synchronized([GameState class])
    {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of the GameState singleton");
        sharedInstance = [super alloc];
        return sharedInstance;
    }
    return nil;
}

- (void) save {
    //saveData(self. @"GameState");
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:achieved100points forKey:@"Achieved100points"];
    [encoder encodeBool:achieved100points forKey:@"Achieved200points"];
    [encoder encodeBool:achieved100points forKey:@"Achieved300points"];
    [encoder encodeBool:achieved100points forKey:@"Achieved400points"];
    [encoder encodeBool:solvedAWordBelow5sec forKey:@"SolvedAWordBelow5sec"];
    [encoder encodeBool:solvedAWordBelow5sec forKey:@"SolvedAWordBelow10sec"];
}

- (id) initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])){
        achieved100points = [decoder decodeBoolForKey:@"Achieved100points"];
        achieved200points = [decoder decodeBoolForKey:@"Achieved200points"];
        achieved300points = [decoder decodeBoolForKey:@"Achieved300points"];
        achieved400points = [decoder decodeBoolForKey:@"Achieved400points"];
        solvedAWordBelow5sec = [decoder decodeBoolForKey:@"SolvedAWordBelow5sec"];
        solvedAWordBelow10sec = [decoder decodeBoolForKey:@"SolvedAWordBelow10sec"];
    }
    return self;
}



@end
