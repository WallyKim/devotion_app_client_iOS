//
//  SettingViewController.h
//  Devotion
//
//  Created by Woong-Ki Kim on 12. 7. 22..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface SettingViewController : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end
