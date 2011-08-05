//
//  GCHelper.m
//  Hackman
//
//  Created by Aditya Herlambang on 8/4/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "GCHelper.h"
#import "GCDatabase.h"

@implementation GCHelper
@synthesize scoresToReport;
@synthesize achievementsToReport;


#pragma mark Loading/Saving
static GCHelper * sharedHelper = nil;

+ (GCHelper *) sharedInstance {
    @synchronized ([GCHelper class])
    {
        if (!sharedHelper){
            sharedHelper = [loadData(@"GameCenterData") retain];
            if (!sharedHelper){
                [[self alloc] initWithScoresToReport:[NSMutableArray array] achievementsToreport:[NSMutableArray array]];
            }
        }
        return sharedHelper;
    }
    return nil;
}

- (void) save
{
    saveData(self, @"GameCenterData");
}

+ (id) alloc{
    @synchronized ([GCHelper class])
    {
        NSAssert(sharedHelper == nil, @"Attempted to allocated a second instance of the GCHelper singleton");
        sharedHelper = [super alloc];
        return sharedHelper;
    }
}

- (BOOL) isGameCenterAvailable{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    NSString * reqSysVer = @"4.1";
    NSString * currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}

- (id) initWithScoresToReport:(NSMutableArray *)theScoresToReport achievementsToreport:(NSMutableArray *)theAchievementsToReport
{
    if ((self = [super init])){
        self.scoresToReport = theScoresToReport;
        self.achievementsToReport = theAchievementsToReport;
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable){
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}

#pragma mark Internal functions

- (void) sendScore:(GKScore *) score{
    [score reportScoreWithCompletionHandler:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                if (error == NULL){
                    NSLog(@"Successfully sent score");
                    [scoresToReport removeObject:score];
                } else {
                    NSLog(@"Score failed to send ... will try again later. Reason: %@", error.localizedDescription);
                }
                            
            });
    }];
}

- (void) sendAchievement:(GKAchievement *) achievement
{
    [achievement reportAchievementWithCompletionHandler:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            if (error == NULL){
                NSLog(@"Successfully sent achievement");
                [achievementsToReport removeObject:achievement];
            } else {
                NSLog(@"Achievement failed to send... will try again later. Reason: %@", error.localizedDescription);
            }
        });
    }];
}

- (void) resendData{
    for (GKAchievement * achievement in achievementsToReport){
        [self sendAchievement:achievement];
    }
    
    for (GKScore * score in scoresToReport){
        [self sendScore:score];
    }
}

- (void) authenticationChanged
{
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
        if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated){
            NSLog(@"Authentication changed: player authenticated.");
            userAuthenticated = TRUE;
            [self resendData];
        } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated){
            NSLog(@"Authentication changed: player not authenticated.");
            userAuthenticated = FALSE;
        }
        
        });
}

#pragma mark User functions

- (void) reportScore:(NSString *)identifier score:(int)rawScore
{
    GKScore * score = [[[GKScore alloc] initWithCategory:identifier] autorelease];
    score.value = rawScore;
    [scoresToReport addObject:score];
    [self save];
    
    if (!gameCenterAvailable || !userAuthenticated)
        return;
    
    [self sendScore:score];
}

- (void) reportAchievement:(NSString *)identifier percentComplete:(double)percentComplete
{
    GKAchievement * achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
    achievement.percentComplete = percentComplete;
    [achievementsToReport addObject:achievement];
    [self save];
    
    if (!gameCenterAvailable || !userAuthenticated) 
        return;

    [self sendAchievement:achievement];
    
}

- (void) authenticateLocalUser
{
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO){
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *) encoder{
    [encoder encodeObject:scoresToReport forKey:@"ScoresToReport"];
    [encoder encodeObject:achievementsToReport forKey:@"AchievementsToReport"];
}

- (id) initWithCoder:(NSCoder *) decoder {
    NSMutableArray * theScoresToReport = [decoder decodeObjectForKey:@"ScoresToReport"];
    NSMutableArray * theAchivementsToReport = [decoder decodeObjectForKey:@"AchievementsToReport"];
    return [self initWithScoresToReport:theScoresToReport achievementsToreport:theAchivementsToReport];
}

@end
