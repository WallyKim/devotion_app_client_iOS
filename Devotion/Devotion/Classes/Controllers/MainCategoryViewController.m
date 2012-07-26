//
//  MainCategoryViewController.m
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 19..
//  Copyright (c) 2012년 NewPerson. All rights reserved.
//

#import "MainCategoryViewController.h"
#import "GuideViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "Category.h"

@interface MainCategoryViewController ()

@property (nonatomic, retain) ServerManager* m_pServerManager;
@property (nonatomic, retain) NSMutableArray* m_pMArrCategories;
@property (nonatomic, retain) NSString* pStrNewVersion;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)goSetting;
- (void)performFetchedResultController;

@end

@implementation MainCategoryViewController

@synthesize m_pServerManager;
@synthesize m_pMArrCategories;
@synthesize pStrNewVersion;
@synthesize fetchedResultsController;

- (void)dealloc
{
    [m_pServerManager release];
    [m_pMArrCategories release];
    [pStrNewVersion release];
    [fetchedResultsController release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        m_pServerManager = [[ServerManager alloc] init];
        m_pMArrCategories = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonSystemItemDone target:self action:@selector(goSetting)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.m_pServerManager = nil;
    self.m_pMArrCategories = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.m_pServerManager getRequestVersionWithDelegate:self];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Events

- (void)goSetting
{
    SettingViewController* pViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController* pNavigationController = [[UINavigationController alloc] initWithRootViewController:pViewController];
    pNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentModalViewController:pNavigationController animated:YES];
    [pViewController release];
    [pNavigationController release];
}

- (void)performFetchedResultController
{
    NSError *error = nil;        
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
	if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    NSManagedObjectContext* managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest	= [[NSFetchRequest alloc] init];
	NSEntityDescription *entity		= [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
    NSSortDescriptor *devotionDescriptor	= [[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
    NSArray *sortDescriptors				= [[NSArray alloc] initWithObjects:devotionDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController	= [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:managedObjectContext 
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:@"Root"];
	self.fetchedResultsController							= aFetchedResultsController;
    fetchedResultsController.delegate						= self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
    [devotionDescriptor release];
    [sortDescriptors release];
	
	return fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger nRow = [self.m_pMArrCategories count];
    return nRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    Category* category = (Category *)[self.m_pMArrCategories objectAtIndex:indexPath.row];
        
    cell.textLabel.text = category.title;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuideViewController *pViewController = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController pushViewController:pViewController animated:YES];
    
    Category* category = (Category *)[self.m_pMArrCategories objectAtIndex:indexPath.row];
    pViewController.m_pLbGuide.text = category.guide;
    
    [[Devotion sharedObject] setPStrCategoryId:category.category_id];
    
    [pViewController release];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
            [self.m_pServerManager getRequestCategoryWithDelegate:self];
            break;
            
        default:
            break;
    }
}

#pragma mark - ServerRequestDelegate

- (void)requestDevotion:(ServerRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)requestDevotion:(ServerRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%d", error.code);
    
    // occur time out
    switch ([error code]) {
        case Enm_TIMEOUT:
        {
            NSLog(@"%@", [request strURL]);
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Geozet"
                                                                message:NSLocalizedString(@"TimeOut", @"Message")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"Button")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
            break;
            
        default:
            break;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000    
    NSLog(@"%@", error.debugDescription);
#endif
}

- (void)requestDevotion:(ServerRequest *)request didLoad:(id)result
{    
    NSLog(@"%@", result);
        
    if ([[request strURL] hasSuffix:@"version.json"])
    {
        NSString* pStrOldVersion = [[NSUserDefaults standardUserDefaults] valueForKey:CATEGORY_VERSION];
        
        NSLog(@"%@", pStrOldVersion);
        
        if (![[result objectForKey:@"version"] isEqualToString:pStrOldVersion])
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                message:@"Contents updated! Try?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", nil];
            [alertView show];
            [alertView release];
            
            pStrNewVersion = [[NSString alloc] initWithString:[result objectForKey:@"version"]];
            
            NSLog(@"%@", pStrNewVersion);
        }
    }
    else if ([[request strURL] hasSuffix:@"users/1.json"])
    {
        [self performFetchedResultController];
        
        NSManagedObjectContext* managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        if ([CoreDataManager deleteTableWithData:self.fetchedResultsController managedObjectContext:managedObjectContext]) {
            NSLog(@"delete success!");
        }
        
        if ([CoreDataManager saveTableWithData:(NSArray *)result toTable:@"Category" managedObjectContext:managedObjectContext]) {
            NSLog(@"insert success!");
            [self performFetchedResultController];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:pStrNewVersion forKey:CATEGORY_VERSION];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:CATEGORY_VERSION]);
        
        self.m_pMArrCategories = (NSMutableArray *)[self.fetchedResultsController fetchedObjects];
                
        [self.tableView reloadData];
    }
}

@end
