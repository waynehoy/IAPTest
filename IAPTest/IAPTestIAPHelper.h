//
//  IAPTestIAPHelper.h
//  IAPTest
//
//  Created by Wayne Hoy on 2014-06-07.
//  Copyright (c) 2014 Wayne Hoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

@protocol IAPTestIAPHelperDelegate
- (void) productsAvailableRefreshed;
@end


@interface IAPTestIAPHelper : IAPHelper

+ (IAPTestIAPHelper *)sharedInstance;
- (void) setDelegate: (id<IAPTestIAPHelperDelegate>)delegate;

- (void) refreshProducts;

- (BOOL) isProduct01Avail;
- (BOOL) isProduct02Avail;
- (BOOL) isProduct03Avail;
- (BOOL) isProduct04Avail;

- (NSDecimalNumber *) product01Price;
- (NSDecimalNumber *) product02Price;
- (NSDecimalNumber *) product03Price;
- (NSDecimalNumber *) product04Price;
@end
