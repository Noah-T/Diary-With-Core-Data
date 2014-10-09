//
//  NATEntryCell.m
//  Diary
//
//  Created by Noah Teshu on 10/8/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATEntryCell.h"
#import "NATDiaryEntry.h"

@interface NATEntryCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation NATEntryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForEntry:(NATDiaryEntry *)entry
{
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 85.0f;
    
    //system font, with sytem fontSize
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    
    //CGFLOAT_MAX has no maximum, infinite  (although it technically says it's non-infinite)
    //217 is the width of the label for the main text body
    //_MAX means there is no cap on max height
    //this crazy line calculates how big the space required for the text will be
    //(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
    //this passes in the font (to help with spacing calculations)
    //@{NSFontAttributeName: font}
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(217, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    
    //if the minimum height is greater, return min height
    //otherwise, return result of calculations for necessary size 
    return MAX(minHeight, CGRectGetHeight(boundingBox)+topMargin +bottomMargin);
}

-(void)configureCellForEntry:(NATDiaryEntry*)entry
{
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    //good practice to cache dateFormatters for large-scale projects
    //something to learn more about next
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //day of week, month day(of month) year
    [dateFormatter setDateFormat:@"EEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    //if the entry has an image, use it. Otherwise, use a placeholder
    if (entry.image) {
        self.imageView.image = [UIImage imageWithData:entry.image];
    } else {
        self.imageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    if (entry.mood == NATDiaryEntryMoodGood) {
        self.imageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if (entry.mood == NATDiaryEntryMoodAverage){
        self.imageView.image = [UIImage imageNamed:@"icn_average"];

    } else if (entry.mood == NATDiaryEntryMoodBad)
                                self.imageView.image = [UIImage imageNamed:@"icn_bad"];

}

@end
