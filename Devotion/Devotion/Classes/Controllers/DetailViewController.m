//
//  DetailViewController.m
//  Devotion
//
//  Created by Woong-Ki Kim on 12. 7. 23..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, retain) IBOutlet UIPageControl* pPageControl;
@property (nonatomic, retain) IBOutlet UIScrollView* pScrollView;
@property (nonatomic, retain) IBOutlet UILabel* pLbTitle;
@property (nonatomic, retain) IBOutlet UILabel* pLbAddress;
@property (nonatomic, retain) IBOutlet UILabel* pLbIntro;
@property (nonatomic, retain) IBOutlet UILabel* pLbContent;
@property (nonatomic, retain) IBOutlet UILabel* pLbApplication;
@property (nonatomic, retain) IBOutlet UIButton* pBtnShare;

- (IBAction)clickedBtn:(id)sender;
- (IBAction)changePageValue:(id)sender;

@end

@implementation DetailViewController

@synthesize pPageControl;
@synthesize pScrollView;
@synthesize pLbTitle;
@synthesize pLbAddress;
@synthesize pLbIntro;
@synthesize pLbContent;
@synthesize pLbApplication;
@synthesize pBtnShare;

- (void)dealloc
{
    [pPageControl release];
    [pScrollView release];
    
    [pLbTitle release];
    [pLbAddress release];
    [pLbIntro release];
    [pLbContent release];
    [pLbApplication release];
    
    [pBtnShare release];
    
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
    
    CGFloat fSizeScrollWidth = 0.0f;
    
    int i = 0;
    for ( ; i < NofPageDetail; i++) {
        fSizeScrollWidth = self.pScrollView.frame.size.width * i;
        NSLog(@"%lf", fSizeScrollWidth);
        switch (i) {
            case 0:
                self.pLbTitle.frame = CGRectMake(24.0f + fSizeScrollWidth, 59.0f, 273.0f, 75.0f);
                self.pLbAddress.frame = CGRectMake(24.0f + fSizeScrollWidth, 170.0f, 273.0f, 21.0f);
                break;
                
            case 1:
                self.pLbIntro.frame = CGRectMake(20.0f + fSizeScrollWidth, 50.0f, 280.0f, 365.0f);
                break;
                
            case 2:
                self.pLbContent.frame = CGRectMake(20.0f + fSizeScrollWidth, 50.0f, 280.0f, 365.0f);
                break;
                
            case 3:
                self.pLbApplication.frame = CGRectMake(20.0f + fSizeScrollWidth, 25.0f, 280.0f, 334.0f);
                self.pBtnShare.frame = CGRectMake(170.0f + fSizeScrollWidth, 380.0f, 144.0f, 37.0f);
                break;
                
            default:
                break;
        }
    }
    
    [self.pScrollView setContentSize:CGSizeMake(self.pScrollView.frame.size.width * i, self.pScrollView.frame.size.height)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [pPageControl removeFromSuperview];
    self.pPageControl = nil;
    
    [pScrollView removeFromSuperview];
    self.pScrollView = nil;
    
    [pLbTitle removeFromSuperview];
    self.pLbTitle = nil;
    
    [pLbAddress removeFromSuperview];
    self.pLbAddress = nil;
    
    [pLbIntro removeFromSuperview];
    self.pLbIntro = nil;
    
    [pLbContent removeFromSuperview];
    self.pLbContent = nil;
    
    [pLbApplication removeFromSuperview];
    self.pLbApplication = nil;
    
    [pBtnShare removeFromSuperview];
    self.pBtnShare = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pLbTitle.text = [[[Devotion sharedObject] pDicDevotion] objectForKey:@"title"];
    self.pLbAddress.text = [[[Devotion sharedObject] pDicDevotion] objectForKey:@"address"];
    self.pLbIntro.text = [[[Devotion sharedObject] pDicDevotion] objectForKey:@"intro"];
    self.pLbContent.text = [[[Devotion sharedObject] pDicDevotion] objectForKey:@"content"];
    self.pLbApplication.text = [[[Devotion sharedObject] pDicDevotion] objectForKey:@"application"];
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

- (IBAction)clickedBtn:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 1:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        case 2:
            NSLog(@"Facebook 공유");
            break;
            
        default:
            break;
    }
}

#pragma mark - UIPageController

- (IBAction)changePageValue:(id)sender
{
    [self.pScrollView setContentOffset:CGPointMake(self.pPageControl.currentPage*320, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;  
    self.pPageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth / NofPageDetail) / pageWidth) + 1;  
}

@end
