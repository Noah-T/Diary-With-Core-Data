//
//  NATDiaryEntry.m
//  Diary
//
//  Created by Noah Teshu on 10/4/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATDiaryEntry.h"


@implementation NATDiaryEntry

//dynamic means that core data will add getters and setters at runtime
@dynamic date;
@dynamic body;
@dynamic image;
@dynamic mood;
@dynamic location;

-(NSString*)sectionName {
    
    //returns how many seconds between blog entry date and beginning of 1970
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //full month name, then year
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    //return the date in a nice, easy to read date format 
    return [dateFormatter stringFromDate:date];
}

@end
