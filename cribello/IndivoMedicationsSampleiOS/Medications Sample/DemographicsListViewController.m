//
//  DemographicsListViewController.m
//  Medications Sample
//
//  Created by Souman Paul on 23/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import "DemographicsListViewController.h"
#import "AppDelegate.h"
#import "IndivoRecord.h"
#import "IndivoDocuments.h"
#import "MedViewController.h"
#import "IndivoDemographics+Special.h"

@interface DemographicsListViewController ()


- (void)showDemographics:(IndivoDemographics *)aMedication animated:(BOOL)animated;
@end


@implementation DemographicsListViewController
@synthesize activeRecord, meds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    NSError *error = nil;
	IndivoDemographics *newMed = (IndivoDemographics *)[activeRecord addDocumentOfClass:[IndivoDemographics class] error:&error];
	if (!newMed) {
		DLog(@"Error: %@", [error localizedDescription]);
		// handle error
		return;
	}
	
	/*******************************************************
	 *  This is the place to setup your medication object  *
	 *******************************************************/
 ///////date of birth/////////
	newMed.dateOfBirth=[INDate new];
    
    NSDateFormatter * dateFormatter1 = [NSDateFormatter new];
    
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
   
    NSDate * date1 = [dateFormatter1 dateFromString:@"2014-08-26"];
    newMed.dateOfBirth.date=date1;
    
    
    //////////gender//////
    newMed.gender=[INGenderType new];
    
    newMed.gender.string=@"male";
    
    newMed.email=[INString new];
    newMed.email.string=@"rita.roy@technicise.com";
    newMed.ethnicity=[INString new];
    newMed.ethnicity.string=@"Indian";
    newMed.preferredLanguage=[INString new];
    newMed.preferredLanguage.string=@"English";
    
    newMed.race=[INString new];
    newMed.race.string=@"Hindu";
    newMed.Name=[INName new];
    newMed.Name.familyName=@"Rita";
    newMed.Name.givenName=@"Rita Roy";
    newMed.Name.middleName=@"Roy";
    newMed.Name.prefix=@"Miss";
    newMed.Name.suffix=@"Paul";
    newMed.Telephone=[NSArray arrayWithObjects:@"9432125529",@"9876543212", nil];
    
    newMed.Address=[INAddress new];
    newMed.Address.country=@"India";
     newMed.Address.city=@"India";
     newMed.Address.postalCode=@"India";
    newMed.Address.region=@"India";
  newMed.Address.street=@"India";
    
    
	/******************************************************/
	
	// push to the server
	[newMed push:^(BOOL didCancel, NSString *errorString) {
		if (errorString) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error pushing to server"
															message:errorString
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}
		else if (!didCancel) {
			self.meds = [meds arrayByAddingObject:newMed];
			[self.tablevView reloadData];
			
			// show the medication
            //	[self showMedication:newMed animated:YES];
			
			// send a natification
			[activeRecord sendMessage:@"New Allergy"
							 withBody:@"A new medication has just been added"
							   ofType:INMessageTypePlaintext
							 severity:INMessageSeverityLow
						  attachments:[NSArray arrayWithObject:newMed]
							 callback:NULL];
		}
	}];

}

- (IBAction)connect:(id)sender {
    // create an activity indicator to show that something is happening
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
	[activityButton setTarget:self];
	[activityButton setAction:@selector(cancelSelection:)];
	self.navigationItem.leftBarButtonItem = activityButton;
	[activityView startAnimating];
	
	// select record
	[APP_DELEGATE.indivo selectRecord:^(BOOL userDidCancel, NSString *errorMessage) {
		
		// there was an error selecting the record
		if (errorMessage) {
			[self connect:[activeRecord label]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect"
															message:errorMessage
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}
		
		// successfully selected record, fetch medications
		else if (!userDidCancel) {
			self.activeRecord = [APP_DELEGATE.indivo activeRecord];
			//[self connect:[activeRecord label]];
			self.navigationItem.rightBarButtonItem.enabled = (nil != self.activeRecord);
			
			// fetch this record's medications
			[activeRecord fetchReportsOfClass:[IndivoDemographics class]
									 callback:^(BOOL success, NSDictionary *__autoreleasing userInfo) {
                                         
                                         // error fetching medications
                                         if (!success) {
                                             NSString *errorMessage = [[userInfo objectForKey:INErrorKey] localizedDescription];
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to get Demographics"
                                                                                             message:errorMessage
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"OK"
                                                                                   otherButtonTitles:nil];
                                             [alert show];
                                         }
                                         
                                         // successfully fetched medications, display
                                         else if (!userDidCancel) {
                                             //DLog(@"%@", [userInfo objectForKey:INResponseStringKey]);
                                             self.meds = [userInfo objectForKey:INResponseArrayKey];
                                             NSLog(@"self.meds.count %@",self.meds);
                                             [self.tablevView reloadData];
                                         }
                                     }];
		}
		
		// cancelled
		else {
			//[self connect:[activeRecord label]];
           // ChartType=@"DemographicsListViewController";
		}
	}];
    

    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (0 == section) {
		return [meds count];
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	if (0 == indexPath.section && [meds count] > indexPath.row) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		// display the name
		IndivoDemographics *med = [meds objectAtIndex:indexPath.row];
		cell.textLabel.text = [med label];
      
        NSLog(@"cell.textlABEL.TEXT  %@",cell.textLabel.text);
		return cell;
	}
	return nil;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 != indexPath.section || indexPath.row >= [meds count]) {
        return;
    }
    
    IndivoDemographics *selected = [meds objectAtIndex:indexPath.row];
    NSLog(@"selected %@",selected);
    //[self showVital:selected animated:YES];
}

/*
- (void)showVital:(IndivoDemographics *)aMedication animated:(BOOL)animated
{
	if (aMedication) {
        IndivoDemographics *viewController = [IndivoDemographics new];
        IndivoDemographics.vitals = aMedication;
        
        [self.navigationController pushViewController:viewController animated:animated];
    }
    
    /*
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.VitalListDetails = [[VitalListDetails alloc] initWithNibName:@"VitalListDetails" bundle:nil];
     VitalListDetails.vitals = aMedication;
     self.window.rootViewController = self.VitalListDetails;
     [self.window makeKeyAndVisible];
     */
    
	
//}

@end
