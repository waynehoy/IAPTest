//
//  IAPViewController.m
//  IAPTest
//
//  Created by Wayne Hoy on 2014-06-07.
//  Copyright (c) 2014 Wayne Hoy. All rights reserved.
//

#import "IAPViewController.h"
#import "IAPTestIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface IAPViewController ()

@end

@implementation IAPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Refresh the list of products
    IAPTestIAPHelper *iap = [IAPTestIAPHelper sharedInstance];
    [iap setDelegate:self];     
    [iap refreshProducts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actP1Purchase:(id)sender {
    NSLog(@"Purchase P1 Pressed");
}
- (IBAction)actP2Purchase:(id)sender {
    NSLog(@"Purchase P2 Pressed");
}
- (IBAction)actP3Purchase:(id)sender {
    NSLog(@"Purchase P3 Pressed");
}

// ===============================================================================
//
// Delegate for IAPTestIAPHelper callbacks
//

// Called when App Store responds with product availability
// Refresh the labels
//
- (void) productsAvailableRefreshed
{
    NSLog(@"Delegate called in IAPViewController");
    
    // Update the labels
    IAPTestIAPHelper *iap = [IAPTestIAPHelper sharedInstance];
    
    if ([iap isProduct01Avail]) {
        self.outP1StateLabel.text = [NSString stringWithFormat:@"P1 Available and costs %@", [iap product01Price]];
    }
    else {
        self.outP1StateLabel.text = @"P1 Not Available";
    }

    if ([iap isProduct02Avail]) {
        self.outP2StateLabel.text = [NSString stringWithFormat:@"P2 Available and costs %@", [iap product02Price]];
    }
    else {
        self.outP2StateLabel.text = @"P2 Not Available";
    }

    if ([iap isProduct03Avail]) {
        self.outP3StateLabel.text = [NSString stringWithFormat:@"P3 Available and costs %@", [iap product03Price]];
    }
    else {
        self.outP3StateLabel.text = @"P3 Not Available";
    }

}

@end
