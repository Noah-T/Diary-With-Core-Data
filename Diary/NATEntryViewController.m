//
//  NATNewEntryViewController.m
//  Diary
//
//  Created by Noah Teshu on 10/8/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATEntryViewController.h"
#import "NATDiaryEntry.h"
#import "NATCoreDataStack.h"

@interface NATEntryViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;

//strong because it will be owner of the picked image
@property (nonatomic, strong) UIImage *pickedImage;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, assign) enum NATDiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@end

@implementation NATEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date;
    // Do any additional setup after loading the view.
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        [self setPickedImage:[UIImage imageWithData:self.entry.image]];
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    } else {
        self.pickedMood = NATDiaryEntryMoodGood;
        date = [NSDate date];
        [self loadLocation];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    //accessory view is only loaded when text field is selected. Neat...
    self.textView.inputAccessoryView = self.accessoryView;
    //make image circular
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //pull up the keyboard right away instead of waiting for user to tap in the textView
    [self.textView becomeFirstResponder];
}

- (void)loadLocation {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    //desired accuracy = withing 1000km (0.62miles)
    self.locationManager.desiredAccuracy = 1000;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //turn this off once a location is obtained (to conserve battery)
    [self.locationManager stopUpdatingLocation];
    
    //the method technically returns an array, we only need one location, though
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.name;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)setPickedMood:(enum NATDiaryEntryMood)pickedMood
{
    _pickedMood = pickedMood;
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    
    //bring alpha from 0.5 to 1.0 if button is selected
    
    switch (pickedMood) {
        case NATDiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
                        break;
        case NATDiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
            


        case NATDiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
            
    }
}

- (void)setPickedImage:(UIImage *)pickedImage
{
    _pickedImage =  pickedImage;
    
    if (pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    } else {
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];

    }
    
}

#pragma mark - Camera Controls

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)promptForSource {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if user didn't cancel
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        
        //if user selected camera
        if (buttonIndex != actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        } else {
            [self promptForPhotoRoll];
        }
    }
}

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate =  self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate =  self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)updateDiaryEntry {
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedMood;
    self.entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
//    entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);

    
    [[NATCoreDataStack defaultStack]saveContext];
}
- (IBAction)doneWasPressed:(id)sender {
    if (self.entry != nil) {
        [self updateDiaryEntry];

    } else {
        [self insertDiaryEntry];
    }

    [self dismissSelf];
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)insertDiaryEntry {
    NATCoreDataStack *coreDateStack = [NATCoreDataStack defaultStack];
    NATDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"NATDiaryEntry" inManagedObjectContext:coreDateStack.managedObjectContext];
    entry.body = self.textView.text;
    entry.date = [[NSDate date]timeIntervalSince1970];
    entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.mood = self.pickedMood;
    entry.location = self.location;
    [coreDateStack saveContext];
}
- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = NATDiaryEntryMoodBad;
}

- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = NATDiaryEntryMoodAverage;
}
- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = NATDiaryEntryMoodGood;
}
- (IBAction)imageButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}


@end
