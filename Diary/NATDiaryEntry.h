//
//  NATDiaryEntry.h
//  Diary
//
//  Created by Noah Teshu on 10/4/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ENUM(int16_t, NATDiaryEntryMood) {
    NATDiaryEntryMoodGood = 0,
    NATDiaryEntryMoodAverage = 1,
    NATDiaryEntryMoodBad = 2
};


@interface NATDiaryEntry : NSManagedObject


@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * body;

//note: when I tried to change this a little bit into development (image to imageData) it crashed the app
//maybe something needed to be cleared...something to look into more
@property (nonatomic, retain) NSData * image;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;

@property (nonatomic, readonly) NSString *sectionName;

@end
