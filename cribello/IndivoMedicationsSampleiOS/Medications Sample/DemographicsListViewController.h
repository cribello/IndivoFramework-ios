//
//  DemographicsListViewController.h
//  Medications Sample
//
//  Created by Souman Paul on 23/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IndivoRecord;
@class IndivoDemographics;

@interface DemographicsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>




@property (nonatomic, strong) IndivoRecord *activeRecord;
@property (nonatomic, strong) NSArray *meds;
@property(nonatomic,strong)IBOutlet UITableView *tablevView;
- (IBAction)add:(id)sender;


- (IBAction)connect:(id)sender;

@end
