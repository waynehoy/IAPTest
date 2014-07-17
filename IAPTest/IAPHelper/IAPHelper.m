//
//  IAPHelper.m
//  IAPTest
//
//  Created by Wayne Hoy on 2014-06-07.
//  Copyright (c) 2014 Wayne Hoy. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {

    // Private instance variables
    SKProductsRequest                   *myProductsRequest;
    RequestProductsCompletionHandler    myCompletionHandler;
    NSSet                               *myProductIdentifiers;
    NSMutableSet                        *myPurchasedProductIdentifiers;
}

// ------------------------------------------------------------
// Initializer
//
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if ((self = [super init]))
    {
        // Store and retain product identifiers
        myProductIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        myPurchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in myProductIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];   // TODO change to app receipt
            if (productPurchased) {
                [myPurchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        // Become the observer for transactions
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
}

// ------------------------------------------------------------
// Send request for avail products
//
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    // Store and retain the completion handler
    // We invoke this handler when the request comes back so the app can update the UI
    myCompletionHandler = [completionHandler copy];
    
    // Create and issue the product availability request
    myProductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:myProductIdentifiers];
    myProductsRequest.delegate = self;
    
    NSLog(@"Products Request: %@", [myProductsRequest description]);
    [myProductsRequest start];
    
}

// ------------------------------------------------------------
// SKProductsRequestDelegate callback, called by the app store
// when request completes
//
// TODO Interesting, the available products are not retained!  Just called back to the app.
//      Everything to do with the request is discarded
//
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    myProductsRequest = nil;
    
    NSLog(@"Response: %@", [response description]);
    NSLog(@"Response Products: %@", [response.products description]);
    NSLog(@"Response Invalid: %@", [response.invalidProductIdentifiers description]);
    NSArray *skProducts = response.products;
    for (SKProduct *skProduct in skProducts)
    {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    // Invoke the client (main app) callback for available products
    myCompletionHandler(YES, skProducts);
    myCompletionHandler = nil;
    
}

// ------------------------------------------------------------
// SKProductsRequestDelegate callback, called by the app store
// when request fails
//
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"Failed to load list of products.");
    myProductsRequest = nil;
    
    myCompletionHandler(NO, nil);
    myCompletionHandler = nil;
}

// ------------------------------------------------------------
// Public methods to make a purchase
//

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [myPurchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

// ------------------------------------------------------------
// Transaction processing helper methods to provide content
//

// Add new method
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [myPurchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

// ------------------------------------------------------------
// SKPaymentTransactionObserver callback methods
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
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
            default:
                break;
        }
    };
}



@end
