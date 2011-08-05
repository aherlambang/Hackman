//
//  OptionsViewController.m
//  Hackman
//
//  Created by Aditya Herlambang on 8/2/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "OptionsViewController.h"
#import "Reachability.h"
#import "HackmanIAPHelper.h"
#import "GCHelper.h"

@implementation OptionsViewController
@synthesize sound = _sound;
@synthesize hud = _hud;

- (void) showLeaderboard{
    GKLeaderboardViewController * leaderboard = [[GKLeaderboardViewController alloc] init];
    if (leaderboard != NULL){
        leaderboard.category = kLeaderboardHackman;
        leaderboard.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboard.leaderboardDelegate = self;
        [self presentModalViewController:leaderboard animated:YES];
    }
}

- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
    [viewController release];
}

- (void) showAchievements{
    GKAchievementViewController * achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL){
        achievements.achievementDelegate = self;
        [self presentModalViewController:achievements animated:YES];
    }
}

- (void) achievementViewControllerDidFinish:
    (GKAchievementViewController *) viewController {
    [self dismissModalViewControllerAnimated:YES];
    [viewController release];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

-(IBAction)switch:(id)sender
{
    NSUserDefaults * userSettings = [NSUserDefaults standardUserDefaults];
    if ([self.sound isOn]){
        [userSettings setObject:@"ON" forKey:@"sound"];
    } else {
        [userSettings setObject:@"OFF" forKey:@"sound"];
    }
}

- (IBAction)menu:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    
}

- (void)productsLoaded:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.tableView reloadData];
    
}

- (void)timeout:(id)arg {
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.title = @"Options";
    
    UIBarButtonItem * menu = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menu:)];
    self.navigationItem.leftBarButtonItem = menu;
    [menu release];
    
    self.sound = [[UISwitch alloc] initWithFrame:CGRectMake(180, 10, 50, 10)];
    [self.sound addTarget:self action:@selector(switch:) forControlEvents:UIControlEventValueChanged];
    NSString * category = [[NSUserDefaults standardUserDefaults] stringForKey:@"category"];
    
    if ([category isEqualToString:@"person"])
        checkedRow = 0;
    else if ([category isEqualToString:@"startups"])
        checkedRow = 1;
    else if ([category isEqualToString:@"planguage"])
        checkedRow = 2;
}

- (void)viewDidUnload
{
    self.hud = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Add new methods
- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    [self.tableView reloadData];    
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
        NSLog(@"No internet connection!");        
    } else {        
        if ([HackmanIAPHelper sharedHelper].products == nil) {
            
            [[HackmanIAPHelper sharedHelper] requestProducts];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
            
        }        
    }

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0 || section == 1)
        return 1;
    else if (section == 2)
        return 3;
    else if (section == 3)
        return 2;
    else
        return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if (section == 1)
        return @"Game Options";
   else if (section == 2)
        return @"Word Categories";
   else if (section == 3)
       return @"Achivements and Leaderboard";
    
   return @"";
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
    if (indexPath.section == 0)
        return 100;
    else
        return 50;

}  
*/

- (IBAction)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;    
    SKProduct *product = [[HackmanIAPHelper sharedHelper].products objectAtIndex:buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[HackmanIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Buying more words";
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0){
        SKProduct *product = [[HackmanIAPHelper sharedHelper].products objectAtIndex:0];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedString = [numberFormatter stringFromNumber:product.price];
        
        cell.textLabel.text = product.localizedTitle;
        cell.detailTextLabel.text = formattedString;
        
        if ([[HackmanIAPHelper sharedHelper].purchasedProducts containsObject:product.productIdentifier]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.accessoryView = nil;
        } else {        
            UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            buyButton.frame = CGRectMake(0, 0, 72, 37);
            [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
            buyButton.tag = indexPath.row;
            [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = buyButton;     
        }
    }
    else if (indexPath.section == 1){
        [cell.textLabel setText:@"Sound Effect"];
        [cell.contentView addSubview:self.sound];
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"Person"];
                if (checkedRow == 0){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            case 1:
                [cell.textLabel setText:@"Startups"];
                if (checkedRow == 1){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            case 2:
                [cell.textLabel setText:@"Programming Language"];
                if (checkedRow == 2){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"Achievements"];
                break;
            case 1:
                [cell.textLabel setText:@"Leaderboard"];
                break;
            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults * userSettings = [NSUserDefaults standardUserDefaults];
    if (indexPath.section == 2){
        checkedRow = indexPath.row;
        switch (indexPath.row) {
            case 0:
                [userSettings setValue:@"person" forKey:@"category"];
                break;
            case 1:
                [userSettings setValue:@"startups" forKey:@"category"];
                break;
            case 2:
                [userSettings setValue:@"planguage" forKey:@"category"];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
                [self showAchievements];
                break;
            case 1:
                [self showLeaderboard];
                break;
            default:
                break;
        }

    }
    [self.tableView reloadData];
}

- (void) dealloc
{
    [_hud release];
    _hud = nil;
    [_sound dealloc];
    [super dealloc];
}

@end
