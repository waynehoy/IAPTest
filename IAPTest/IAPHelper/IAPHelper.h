//
//  IAPHelper.h
//  IAPTest
//
//  Created by Wayne Hoy on 2014-06-07.
//  Copyright (c) 2014 Wayne Hoy. All rights reserved.
//

#import <Foundation/Foundation.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject 

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end
