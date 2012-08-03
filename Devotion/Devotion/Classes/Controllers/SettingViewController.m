//
//  SettingViewController.m
//  Devotion
//
//  Created by Woong-Ki Kim on 12. 7. 22..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

- (void)goClose;

@end

@implementation SettingViewController

- (void)dealloc
{
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
    
    self.title = @"Setting";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(goClose)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"Start Shop!");
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    } else {
        NSLog(@"Failed Shop!");
    }
    
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"D01"]];
    productRequest.delegate = self;
	
    [productRequest start];
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

- (void)goClose
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:				
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"SKPaymentTransactionStateRestored");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"SKPaymentTransactionStateFailed");	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"SKPaymentTransactionStatePurchased");
    
	NSLog(@"Trasaction Identifier : %@", transaction.transactionIdentifier);
	NSLog(@"Trasaction Date : %@", transaction.transactionDate);
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"SKProductRequest got response");
	if( [response.products count] > 0 ) {
		SKProduct *product = [response.products objectAtIndex:0];
		NSLog(@"Title : %@", product.localizedTitle);
		NSLog(@"Description : %@", product.localizedDescription);
		NSLog(@"Price : %@", product.price);
	}
	
	if( [response.invalidProductIdentifiers count] > 0 ) {
		NSString *invalidString = [response.invalidProductIdentifiers objectAtIndex:0];
		NSLog(@"Invalid Identifiers : %@", invalidString);
	}
}

@end
