//
//  TTInputToolBarView.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/10.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TTInputToolBarView.h"
#import "Masonry.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

@interface TTInputToolBarView ()



@end

@implementation TTInputToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor alloc] initWithRed:222/255.0 green:220.0/255 blue:223/255.0 alpha:1.0];
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreen_Width-80, 35)];
        self.textView.layer.cornerRadius = 2.0f;
        [self addSubview:_textView];
        
        self.senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.senderButton.frame = CGRectMake(self.textView.frame.origin.x + self.textView.frame.size.width + 5,5, 60, 40);
        [self.senderButton setTitle:@"发送" forState:UIControlStateNormal];
        self.senderButton.backgroundColor = [[UIColor alloc]initWithRed:222/255.0 green:220.0/255 blue:223/255.0 alpha:1.0];
        self.senderButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [self.senderButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self addSubview:_senderButton];
    }
    return self;
}




@end
