//
//  IAPViewController.h
//  IAPTest
//
//  Created by Wayne Hoy on 2014-06-07.
//  Copyright (c) 2014 Wayne Hoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAPTestIAPHelper.h"


@interface IAPViewController : UIViewController <IAPTestIAPHelperDelegate>

@property (weak, nonatomic) IBOutlet UILabel *outP1StateLabel;
@property (weak, nonatomic) IBOutlet UILabel *outP2StateLabel;
@property (weak, nonatomic) IBOutlet UILabel *outP3StateLabel;


- (IBAction)actP1Purchase:(id)sender;
- (IBAction)actP2Purchase:(id)sender;
- (IBAction)actP3Purchase:(id)sender;

@end
