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

@interface MainCategoryViewController ()

@property (nonatomic, retain) ServerManager* m_pServerManager;
@property (nonatomic, retain) NSMutableArray* m_pMArrCategories;

- (void)goSetting;

@end

@implementation MainCategoryViewController

@synthesize m_pServerManager;
@synthesize m_pMArrCategories;

- (void)dealloc
{
    [m_pServerManager release];
    [m_pMArrCategories release];
    
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
    
    [self.m_pServerManager getRequestCategoryWithDelegate:self];
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
    
    NSDictionary* pDicCategory = (NSDictionary *)[self.m_pMArrCategories objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [pDicCategory objectForKey:@"title"];
    
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
    
    NSDictionary* pDicCategory = (NSDictionary *)[self.m_pMArrCategories objectAtIndex:indexPath.row];
    pViewController.m_pLbGuide.text = [pDicCategory objectForKey:@"guide"];
    
    [[Devotion sharedObject] setPStrCategoryId:[pDicCategory objectForKey:@"id"]];
    
    [pViewController release];
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
    
    if ([result count] == 0)
    {
        [self.m_pServerManager getRequestCategoryWithDelegate:self];
    }
    else
    {
        self.m_pMArrCategories = result;
        
        [self.tableView reloadData];   
    }
}

@end
