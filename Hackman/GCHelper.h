//
//  GCHelper.h
//  Hackman
//
//  Created by Aditya Herlambang on 8/4/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#define kAchieved100points @"com.adityaherlambang.achievement.100points"
#define kAchieved200points @"com.adityaherlambang.achievement.200points"
#define kAchieved300points @"com.adityaherlambang.achievement.300points"
#define kAchieved400points @"com.adityaherlambang.achievement.400points"
#define kAchieved5seconds  @"com.adityaherlambang.achievement.5second"
#define kAchieved10seconds @"com.adityaherlambang.achievement.10second"
#define kLeaderboardHackman @"com.adityaherlambang.hackman.leaderboard.score"

@interface GCHelper : NSObject
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    NSMutableArray * scoresToReport;
    NSMutableArray * achievementToReport;
}


@property (retain) NSMutableArray * scoresToReport;
@property (retain) NSMutableArray * achievementsToReport;


+ (GCHelper *) sharedInstance;
- (void) authenticationChanged;
- (void) authenticateLocalUser;

- (void) save;
- (id) initWithScoresToReport:(NSMutableArray *) scoresToReport
         achievementsToreport:(NSMutableArray *) achievementsToReport;
- (void) reportAchievement:(NSString *) identifier
           percentComplete:(double) percentComplete;
- (void) reportScore:(NSString *) identifier score:(int) score;


@end
