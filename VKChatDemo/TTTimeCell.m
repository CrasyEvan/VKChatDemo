//
//  XMGTimeCell.m
//  xmg1chat
//
//  Created by xiaomage on 15/9/28.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "TTTimeCell.h"

#define kText_Font [UIFont systemFontOfSize:11]
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

@interface TTTimeCell ()

@end

@implementation TTTimeCell

- (UILabel *)timeLabel {
    
    if(!_timeLabel) {

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.layer.cornerRadius = 8.0f;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.backgroundColor = [UIColor colorWithRed:223/255.0 green:220/255.0 blue:223.0/255.0 alpha:1.0];
        _timeLabel.font = kText_Font;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSDictionary *attributes = @{NSFontAttributeName:kText_Font};
    CGSize contentSize=[self.timeLabel.text boundingRectWithSize:CGSizeMake(100, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.timeLabel.frame = CGRectMake(kScreen_Width/2-(contentSize.width+15)/2, 0, contentSize.width+15, 18);
}



@end
