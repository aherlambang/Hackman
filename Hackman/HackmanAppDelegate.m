//
//  HackmanAppDelegate.m
//  Hackman
//
//  Created by Aditya Herlambang on 7/31/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "HackmanAppDelegate.h"
#import "MainViewController.h"

@implementation HackmanAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString * startupPlist = @"/Developer/Hangman/Hackman/Hackman/startups.plist";
    NSString * namesPlist = @"/Developer/Hangman/Hackman/Hackman/names.plist";
    NSString * programmingPlist = @"/Developer/Hangman/Hackman/Hackman/programming.plist";
    
    
    NSArray * arr = [NSArray arrayWithObjects:@"AIRBNB",@"LOOPT", @"FOURSQUARE", @"GOWALLA", @"FLIPBOARD", @"ZYNGA",
                                              @"YCOMBINATOR", @"JUSTINTV", @"TUMBLR", @"ZIPCAR", @"ZAARLY", @"PATH", 
                                              @"POSTEROUS", @"FACEBOOK", @"SEATME", @"BITCOIN", @"NING", @"OOYALA", 
                                              @"VIDEOSURF", @"DROPBOX", @"FIXYA", @"ZAZZLE",@"MEEBO",@"USTREAM", @"LOCALMIND",
                                              @"GROUPON", nil];
    //[arr writeToFile:startupPlist atomically:YES];
    
    NSArray * arr1 = [NSArray arrayWithObjects:@"PAUL GRAHAM",@"PETER THIEL", @"DAVE MCCLURE", @"JESSICA LIVINGSTON", @"NIKET DESAY", @"RON CONWAY", 
                                               @"ARRINGTON", @"ROBERT SCOBLE", @"EVAN WILLIAMS", @"KEVIN ROSE", @"MITCH KAPOR", @"JOHN DOERR",
                                                nil];
    //[arr1 writeToFile:namesPlist atomically:YES];
    
    NSArray * arr2 = [NSArray arrayWithObjects:@"",@"",nil];
    //[arr2 writeToFile:programmingPlist atomically:YES];
    
    // Override point for customization after application launch.
	
	// Create the view controller
	MainViewController * main = [[MainViewController alloc] init];
		
	// Display the window
	[_window addSubview:main.view];
	[_window makeKeyAndVisible];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
