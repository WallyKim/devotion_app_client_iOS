//
//  GuideViewController.m
//  Devotion
//
//  Created by Woong-Ki Kim on 12. 7. 21..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "GuideViewController.h"
#import "DevotionListViewController.h"

@interface GuideViewController ()

- (IBAction)gestureSwipe:(id)sender;

@end

@implementation GuideViewController

@synthesize m_pLbGuide;

- (void)dealloc
{
    [m_pLbGuide release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [m_pLbGuide removeFromSuperview];
    self.m_pLbGuide = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Events

- (IBAction)gestureSwipe:(id)sender
{
    NSLog(@"gesture");
    DevotionListViewController *pViewController = [[DevotionListViewController alloc] initWithStyle:UITableViewStylePlain];
    // ...
    // Pass the selected object to the new view controller.
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:pViewController animated:YES];
    [pViewController release];
}

@end
