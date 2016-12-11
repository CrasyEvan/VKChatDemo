//
//  TTInputToolBarView.h
//  VKChatDemo
//
//  Created by Evan on 2016/12/10.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TTInputToolBarView : UIView

@property (nonatomic, strong) UIButton *senderButton;
@property (nonatomic, strong) UITextView *textView;


- (instancetype)initWithFrame:(CGRect)frame;

@end
