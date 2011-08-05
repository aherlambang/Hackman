//
//  IAPHelper.h
//  Hackman
//
//  Created by Aditya Herlambang on 8/3/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;

}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;

- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProductIdentifier:(NSString *)productIdentifier;


@end
