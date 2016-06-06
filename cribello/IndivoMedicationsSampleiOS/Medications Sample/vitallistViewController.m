//
//  vitallistViewController.m
//  Medications Sample
//
//  Created by Souman Paul on 22/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import "vitallistViewController.h"
#import "AppDelegate.h"
#import "IndivoRecord.h"
#import "IndivoDocuments.h"
#import "MedViewController.h"
#import "VitalListDetails.h"

@interface vitallistViewController ()
{
    NSString *string;
    
}
- (void)showVital:(IndivoVitalSigns *)aMedication animated:(BOOL)animated;
@end

@implementation vitallistViewController
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsPortrait(interfaceOrientation);
}



#pragma mark - Record Handling
/**
 *	Called when the user logged out
 */
- (void)unloadData
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.activeRecord = nil;
	self.meds = nil;
	[self.tablevView reloadData];
	[self connect:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)add:(id)sender {
    
    NSError *error = nil;
	IndivoVitalSigns *newMed = (IndivoVitalSigns *)[activeRecord addDocumentOfClass:[IndivoVitalSigns class] error:&error];
	if (!newMed) {
		DLog(@"Error: %@", [error localizedDescription]);
		// handle error
		return;
	}
	
	/*******************************************************
	 *  This is the place to setup your medication object  *
	 *******************************************************/
    //// heart_rate
    double rating=50.0;
    NSDecimalNumber *number=(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:rating];
    
    newMed.heart_rate=[INVitalSign new];
    newMed.heart_rate.unit=@"{beats}/min";
    /////vul ache
    newMed.heart_rate.value=number;
    ////
    
    newMed.heart_rate.name=[INCodedValue new];
    
	newMed.heart_rate.name.title = @"Heart rate";
    newMed.heart_rate.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.heart_rate.name.identifier = @"8867-4";
    
    //height
    newMed.height=[INVitalSign new];
    newMed.height.unit=@"m";
    /////vul ache
    newMed.height.value=number;
    ////
    
    newMed.height.name=[INCodedValue new];
    
	newMed.height.name.title = @"Body height";
    newMed.height.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.height.name.identifier = @"8302-2";


    ///respiratory_rate
    newMed.respiratory_rate=[INVitalSign new];
    newMed.respiratory_rate.unit=@"{breaths}/min";
    /////vul ache
    newMed.respiratory_rate.value=number;
    ////
    
    newMed.respiratory_rate.name=[INCodedValue new];
    
	newMed.respiratory_rate.name.title = @"Respiration rate";
    newMed.respiratory_rate.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.respiratory_rate.name.identifier = @"9279-1";

    
    //weight
    newMed.weight=[INVitalSign new];
    newMed.weight.unit=@"kg";
    /////vul ache
    newMed.weight.value=number;
    ////
    
    newMed.weight.name=[INCodedValue new];
    
	newMed.weight.name.title = @"Body weight";
    newMed.weight.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.weight.name.identifier = @"3141-9";
    
    
    
//    newMed.encounter=[INVitalSign new];
//    newMed.weight.unit=@"kg";
//    /////vul ache
//    newMed.weight.value=(__bridge NSDecimalNumber *)(rating);
//    ////
//    
//    newMed.weight.name=[INCodedValue new];
//    
//	newMed.weight.name.title = @"Body weight";
//    newMed.weight.name.system = @"http://purl.bioontology.org/ontology/LNC/";
//    newMed.weight.name.identifier = @"3141-9";
    
    //oxygen_saturation
    
    newMed.oxygen_saturation=[INVitalSign new];
    newMed.oxygen_saturation.unit=@"%{HemoglobinSaturation}";
    /////vul ache
    newMed.oxygen_saturation.value=number;
    ////
    
    newMed.oxygen_saturation.name=[INCodedValue new];
    
	newMed.oxygen_saturation.name.title = @"Oxygen saturation";
    newMed.oxygen_saturation.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.oxygen_saturation.name.identifier = @"2710-2";
    
////temparature
    newMed.temperature=[INVitalSign new];
    newMed.temperature.unit=@"Cel";
    /////vul ache
    newMed.temperature.value=number;
    ////
    
    newMed.temperature.name=[INCodedValue new];
    
	newMed.temperature.name.title = @"Body temperature";
    newMed.temperature.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.temperature.name.identifier = @"8310-5";
    
    ///bmi
    newMed.bmi=[INVitalSign new];
    newMed.bmi.unit=@"kg/m2";
    /////vul ache
    newMed.bmi.value=number;
    ////
    
    newMed.bmi.name=[INCodedValue new];
    
	newMed.bmi.name.title = @"Body mass index";
    newMed.bmi.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.bmi.name.identifier = @"39156-5";

    ////bp  thik korte
    
    newMed.bp=[INBloodPressure new];
    newMed.bp.systolic=[INVitalSign new];
    newMed.bp.systolic.unit=@"mm[Hg]";
      newMed.bp.systolic.value=number;
    
    newMed.bp.systolic.name=[INCodedValue new];
    
	newMed.bp.systolic.name.title = @"Body mass index";
    newMed.bp.systolic.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.bp.systolic.name.identifier = @"8480-6";
    
    
    //newMed.bp=[INBloodPressure new];
    newMed.bp.diastolic=[INVitalSign new];
    newMed.bp.diastolic.unit=@"mm[Hg]";
    newMed.bp.diastolic.value=number;
    
    newMed.bp.diastolic.name=[INCodedValue new];
    
	newMed.bp.diastolic.name.title = @"Intravascular diastolic";
    newMed.bp.diastolic.name.system = @"http://purl.bioontology.org/ontology/LNC/";
    newMed.bp.diastolic.name.identifier = @"8462-4";
    
    
    
   // newMed.bp=[INBloodPressure new];
    newMed.bp.method=[INCodedValue new];
   	newMed.bp.method.title = @"Intravascular diastolic";
    newMed.bp.method.system = @"http://smartplatforms.org/terms/codes/BloodPressureMethod#";
    newMed.bp.method.identifier = @"palpation";

    
  //  newMed.bp=[INBloodPressure new];
    newMed.bp.site=[INCodedValue new];
   	newMed.bp.site.title = @"Intravascular diastolic";
    newMed.bp.site.system = @"http://purl.bioontology.org/ontology/SNOMEDCT/";
    newMed.bp.site.identifier = @"61396006";
    
    
    //  newMed.bp=[INBloodPressure new];
    newMed.bp.position=[INCodedValue new];
   	newMed.bp.position.title = @" ";//@"Intravascular diastolic";
    newMed.bp.position.system = @"http://purl.bioontology.org/ontology/SNOMEDCT/";
    newMed.bp.position.identifier = @"40199007";

    
    ////////aj ei porjonto baki ache diastolic, method, site, position
    
    
    
    ////encounter
    
    
    newMed.encounter=[IndivoEncounter new];
    //////
    newMed.encounter.facility=[INOrganization new];
    //////
    
    //newMed.encounter.startDate=[INDateTime new];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ssZ";
    
    NSDate *now = [NSDate date];
    NSString *formattedDateString = [dateFormatter stringFromDate:now];
    
    INDateTime *Datetime=[INDateTime dateFromISOString:formattedDateString];
    
    newMed.encounter.startDate=Datetime;
    
    
    
   newMed.encounter.endDate=Datetime;
    
    newMed.encounter.provider=[INProvider new];
     newMed.encounter.provider.dea_number=@"dear time";
    
    newMed.encounter.provider.ethnicity=@"indian";
    newMed.encounter.provider.race=@"race";
    newMed.encounter.provider.npi_number=@"12345";
    newMed.encounter.provider.preferred_language=@"bengali";
    newMed.encounter.provider.adr=[INAddress new];
    
    newMed.encounter.provider.adr.country=@"India";
     newMed.encounter.provider.adr.city=@"kolkata";
     newMed.encounter.provider.adr.postalCode=@"66213";
     newMed.encounter.provider.adr.region=@"region";
     newMed.encounter.provider.adr.street=@"bamangachi bamon para";
    
    newMed.encounter.provider.bday=[INDateTime new];
    NSDateFormatter * dateFormatter1 = [NSDateFormatter new];
    
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date = [dateFormatter1 dateFromString:@"2014-08-26"];

    newMed.encounter.provider.bday.date=date;
    
    newMed.encounter.provider.email=@"rita.paul@gmail.com";
    newMed.encounter.provider.name=[INName new];
   //  newMed.encounter.provider.name.familyName=@"ma";
   //  newMed.encounter.provider.name.givenName=@"banik";
//     newMed.encounter.provider.name.middleName=@"dutta";
//     newMed.encounter.provider.name.prefix=@"prefix";
//    newMed.encounter.provider.name.suffix=@"suffix";
//
    
//    newMed.encounter.provider.tel_1=[INTelephone new];
//    newMed.encounter.provider.tel_1.type=[INPhoneType new];
//    
//    newMed.encounter.provider.tel_1.number=@"2435432234";
//    newMed.encounter.provider.tel_1.preferred=[INBool new];
//    
//    
//    newMed.encounter.provider.tel_2=[INTelephone new];
//    newMed.encounter.provider.tel_2.type=[INPhoneType new];
//    
//    newMed.encounter.provider.tel_2.number=@"2435432234";
//    newMed.encounter.provider.tel_2.preferred=[INBool new];
//    
//    
    newMed.encounter.provider.gender=[INNormalizedString new];
//    
//    
    newMed.encounter.encounterType=[INCodedValue new];
    newMed.encounter.encounterType.system=@"http://smartplatforms.org/terms/codes/EncounterType#";
    newMed.encounter.encounterType.identifier=@"home";
    newMed.encounter.encounterType.title=@"title";
//    
//    
    
    /////encounter
    // r baki ache encounter putro ta
    
   
    
    
    newMed.date = [INDateTime now];
	
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
			[activeRecord fetchReportsOfClass:[IndivoVitalSigns class]
									 callback:^(BOOL success, NSDictionary *__autoreleasing userInfo) {
                                         
                                         // error fetching medications
                                         if (!success) {
                                             NSString *errorMessage = [[userInfo objectForKey:INErrorKey] localizedDescription];
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to get medications"
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
		IndivoVitalSigns *med = [meds objectAtIndex:indexPath.row];
		cell.textLabel.text = [med label];
        string=cell.textLabel.text;
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
    
    IndivoVitalSigns *selected = [meds objectAtIndex:indexPath.row];
     NSLog(@"selected %@",selected);
    [self showVital:selected animated:YES];
}
- (void)showVital:(IndivoVitalSigns *)aMedication animated:(BOOL)animated
{
	if (aMedication) {
        VitalListDetails *viewController = [VitalListDetails new];
        viewController.vitals = aMedication;
       
        [self.navigationController pushViewController:viewController animated:animated];
    }
        
      /*
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.VitalListDetails = [[VitalListDetails alloc] initWithNibName:@"VitalListDetails" bundle:nil];
        VitalListDetails.vitals = aMedication;
        self.window.rootViewController = self.VitalListDetails;
        [self.window makeKeyAndVisible];
      */
        
	
}

@end
