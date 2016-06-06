//
//  VitalListDetails.h
//  Medications Sample
//
//  Created by Souman Paul on 23/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vitallistViewController.h"


@class IndivoVitalSigns;
@class IndivoRecord;
@interface VitalListDetails : UIViewController<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UILabel *Title;


@property (strong, nonatomic) IBOutlet UILabel *identifier;
@property (nonatomic, strong) IndivoRecord *activeRecord;

@property (strong, nonatomic) IndivoVitalSigns *vitals;

//@property (strong, nonatomic) IndivoVitalSigns *vitals;

@end
