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

@interface NATEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation NATEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.entry != nil) {
        self.textField.text = self.entry.body;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateDiaryEntry {
    self.entry.body = self.textField.text;
    
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
    entry.body = self.textField.text;
    entry.date = [[NSDate date]timeIntervalSince1970];
    [coreDateStack saveContext];
}



@end
