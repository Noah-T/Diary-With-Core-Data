//
//  NATEntryCell.h
//  Diary
//
//  Created by Noah Teshu on 10/8/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NATDiaryEntry;

@interface NATEntryCell : UITableViewCell

+ (CGFloat)heightForEntry:(NATDiaryEntry*)entry;

-(void)configureCellForEntry:(NATDiaryEntry*)entry;
@end
