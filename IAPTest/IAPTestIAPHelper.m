//
//  IAPTestIAPHelper.m
//  IAPTest
//
//  Created by Wayne Hoy on 2014-06-07.
//  Copyright (c) 2014 Wayne Hoy. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "IAPTestIAPHelper.h"
#import "IAPHelper.h"

@interface IAPTestIAPHelper () {
    NSArray *myProductsArray;
    id<IAPTestIAPHelperDelegate> myDelegate;
}

// Helper declarations
- (SKProduct *) _findProduct: (NSString *)pid;

@end


@implementation IAPTestIAPHelper

// ------------------------------------------------------------
// Singleton pattern accessor for a concrete IAP helper
//
+ (IAPTestIAPHelper *)sharedInstance
{
    static dispatch_once_t once;
    static IAPTestIAPHelper * sharedInstance;
    
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"PRODUCT01", @"PRODUCT02", @"PRODUCT03", @"PRODUCT04",
                                      @"com.melroth.learning-iap.PRODUCT01",
                                      @"com.melroth.learning-iap.PRODUCT02",
                                      @"com.melroth.learning-iap.PRODUCT03",
                                      @"com.melroth.learning-iap.PRODUCT04",
                                      nil];
        NSLog(@"Initialized with product IDs: %@", [productIdentifiers description]);
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    self = [super initWithProductIdentifiers:productIdentifiers];
    myProductsArray = nil;
    myDelegate = nil;
    return self;
}

- (void) setDelegate: (id<IAPTestIAPHelperDelegate>)delegate
{
    myDelegate = delegate;
}


- (void) refreshProducts
{
    [super requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            myProductsArray = products;
            if (myDelegate != nil) {
                [myDelegate productsAvailableRefreshed];
                myDelegate = nil;
            }
        }
    }];
}


- (BOOL) isProduct01Avail
{
    NSDecimalNumber *price = [self product01Price];
    return (price != nil);
}
- (BOOL) isProduct02Avail
{
    NSDecimalNumber *price = [self product02Price];
    return (price != nil);
}
- (BOOL) isProduct03Avail
{
    NSDecimalNumber *price = [self product03Price];
    return (price != nil);
}
- (BOOL) isProduct04Avail
{
    NSDecimalNumber *price = [self product04Price];
    return (price != nil);
}

- (NSDecimalNumber *) product01Price
{
    SKProduct *prod = [self _findProduct:@"PRODUCT01"];
    if (prod != nil) {
        return prod.price;
    }
    return nil;
}
- (NSDecimalNumber *) product02Price
{
    SKProduct *prod = [self _findProduct:@"PRODUCT02"];
    if (prod != nil) {
        return prod.price;
    }
    return nil;
}
- (NSDecimalNumber *) product03Price
{
    SKProduct *prod = [self _findProduct:@"PRODUCT03"];
    if (prod != nil) {
        return prod.price;
    }
    return nil;
}
- (NSDecimalNumber *) product04Price
{
    SKProduct *prod = [self _findProduct:@"PRODUCT04"];
    if (prod != nil) {
        return prod.price;
    }
    return nil;
}

- (SKProduct *) _findProduct: (NSString *)pid
{
    for (SKProduct *skProduct in myProductsArray)
    {
        if ([skProduct.productIdentifier caseInsensitiveCompare:pid] == NSOrderedSame) {
            return skProduct;
        }
    }
    return nil;    
}

@end
