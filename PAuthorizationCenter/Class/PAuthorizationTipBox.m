//
//  PAuthorizationTipBox.m
//  Camera360
//
//  Created by C360_liyanjun on 16/3/2.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import "PAuthorizationTipBox.h"
#import <PureLayout/PureLayout.h>
#import "PAuthorizationCenter.h"
#import "PGLocalizationDefines.h"

/** 默认视图的宽度和高度 */
#ifndef kDefaultViewWidth
#define kDefaultViewWidth  (CGRectGetWidth([UIScreen mainScreen].bounds))
#endif

static const CGFloat iPhone6Width = 375;
static const CGFloat containerWidth = 270;
static const CGFloat topImageHeight = 65;
static const CGFloat bottomImageHeight = 70;
static const CGFloat buttonHeight = 44;
static const CGFloat contentHeight = 65;
static const CGFloat labelLeft_Right_Space = 30;

@interface PAuthorizationTipBox ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *topRightImageView;
@property (nonatomic, strong) UIView *containerLabelView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIView *containerButtonView;
@property (nonatomic, strong) UIButton *leftButton;
//需求又修改为要求只有一个按钮 所以屏蔽掉一个按钮
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) NSLayoutConstraint *contentConstraint;
@property (nonatomic, strong) NSLayoutConstraint *containerConstraint;
@property (nonatomic, strong) NSLayoutConstraint *containerLabelConstraint;

@end

@implementation PAuthorizationTipBox

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    NSString *title = PText(@"notification_camera360_title",nil);
    NSString *content = PText(@"notification_camera360_tips", nil);
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    _containerView = [[UIView alloc] initForAutoLayout];
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.cornerRadius = 15;
    _containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_containerView];
    [_containerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_containerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_containerView autoSetDimension:ALDimensionWidth toSize:(containerWidth*kDefaultViewWidth)/iPhone6Width];
    _containerConstraint = [_containerView autoSetDimension:ALDimensionHeight toSize:(topImageHeight + bottomImageHeight + buttonHeight + 1 + contentHeight)*kDefaultViewWidth/iPhone6Width];
    
    
    _topRightImageView = [[UIImageView alloc] initForAutoLayout];
    _topRightImageView.layer.masksToBounds = YES;
    _topRightImageView.layer.cornerRadius = 14;
    _topRightImageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homemageX_PauthorizationTopBox_TopRight" ofType:@"png"]];
    [self addSubview:_topRightImageView];
    [_topRightImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_containerView withOffset:14];
    [_topRightImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_containerView withOffset:14];
    [_topRightImageView autoSetDimensionsToSize:CGSizeMake(28, 28)];
    
    
    _topImageView = [[UIImageView alloc] initForAutoLayout];
    [_containerView addSubview:_topImageView];
    [_topImageView autoSetDimensionsToSize:CGSizeMake((containerWidth*kDefaultViewWidth)/iPhone6Width , (topImageHeight*kDefaultViewWidth)/iPhone6Width)];
    [_topImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_topImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    _topImageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homemageX_PauthorizationTopBox_Top" ofType:@"png"]];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.clipsToBounds = YES;
    
    
    _containerLabelView = [[UIView alloc] initForAutoLayout];
    _containerLabelView.backgroundColor = COLOR_WITH_HEX(0xfbce15);
    [_containerView addSubview:_containerLabelView];
    [_containerLabelView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_topImageView];
    [_containerLabelView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_containerLabelView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    _containerLabelConstraint = [_containerLabelView autoSetDimension:ALDimensionHeight toSize:contentHeight*kDefaultViewWidth/iPhone6Width];
    
    _titleLabel = [[UILabel alloc] initForAutoLayout];
    [_containerLabelView addSubview:_titleLabel];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    _titleLabel.shadowOffset = CGSizeMake(0, 1);
    _titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = 5.0;
    
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [titleParagraphStyle setLineSpacing:5];
    titleParagraphStyle.alignment = NSTextAlignmentCenter;
    [titleAttributedString addAttribute:NSParagraphStyleAttributeName value:titleParagraphStyle range:NSMakeRange(0, [title length])];
    [titleAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, [title length])];
    _titleLabel.attributedText = titleAttributedString;
    CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(containerWidth*kDefaultViewWidth/iPhone6Width - 2*labelLeft_Right_Space, MAXFLOAT)];
    
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:labelLeft_Right_Space];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:labelLeft_Right_Space];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_titleLabel autoSetDimension:ALDimensionHeight toSize:titleSize.height];
    
    
    _contentLabel = [[UILabel alloc] initForAutoLayout];
    [_containerLabelView addSubview:_contentLabel];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    _contentLabel.shadowOffset = CGSizeMake(0, 1);
    _contentLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _contentLabel.font = [UIFont boldSystemFontOfSize:15];
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [contentParagraphStyle setLineSpacing:10];
    contentParagraphStyle.alignment = NSTextAlignmentCenter;
    [contentAttributedString addAttribute:NSParagraphStyleAttributeName value:contentParagraphStyle range:NSMakeRange(0, [content length])];
    [contentAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, [content length])];
    _contentLabel.attributedText = contentAttributedString;
    CGSize contentSize = [_contentLabel sizeThatFits:CGSizeMake(containerWidth*kDefaultViewWidth/iPhone6Width - 2*labelLeft_Right_Space, MAXFLOAT)];
    
    [_contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:labelLeft_Right_Space];
    [_contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:labelLeft_Right_Space];
    [_contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:15];
    [_contentLabel autoSetDimension:ALDimensionHeight toSize:contentSize.height];
    
    _bottomImageView = [[UIImageView alloc] initForAutoLayout];
    [_containerView addSubview:_bottomImageView];
    [_bottomImageView autoSetDimensionsToSize:CGSizeMake((containerWidth*kDefaultViewWidth)/iPhone6Width , (bottomImageHeight*kDefaultViewWidth)/iPhone6Width)];
    [_bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_bottomImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_containerLabelView];
    _bottomImageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homemageX_PauthorizationTopBox_Bottom" ofType:@"png"]];
    _bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bottomImageView.clipsToBounds = YES;

    _containerButtonView = [[UIView alloc] initForAutoLayout];
    _containerButtonView.backgroundColor = COLOR_WITH_HEX(0xcba403);
    [_containerView addSubview:_containerButtonView];
    [_containerButtonView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_bottomImageView];
    [_containerButtonView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_containerButtonView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_containerButtonView autoSetDimension:ALDimensionHeight toSize:((buttonHeight+1)*kDefaultViewWidth)/iPhone6Width];
    
    
    _leftButton = [UIButton newAutoLayoutView];
    [_containerButtonView addSubview:_leftButton];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftButton setBackgroundImage:[UIImage imageFromColor:COLOR_WITH_HEX(0xf6b900)] forState:UIControlStateHighlighted];
    [_leftButton setBackgroundImage:[UIImage imageFromColor:COLOR_WITH_HEX(0xfbce15)] forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _leftButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    _leftButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_leftButton setTitle:PText(@"notification_camera360_ok",nil) forState:UIControlStateNormal];
    [_leftButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_leftButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.5];
    [_leftButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_leftButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    //需求又修改为要求只有一个按钮 所以屏蔽掉一个按钮
//    [_leftButton autoSetDimension:ALDimensionWidth toSize:((containerWidth*kDefaultViewWidth)/iPhone6Width)/2 - 0.5];
    [_leftButton addTarget:self action:@selector(requestNotificationsAuthorization:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [UIButton newAutoLayoutView];
    _rightButton.hidden = YES;
    [_containerButtonView addSubview:_rightButton];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setBackgroundImage:[UIImage imageFromColor:COLOR_WITH_HEX(0xf6b900)] forState:UIControlStateHighlighted];
    [_rightButton setBackgroundImage:[UIImage imageFromColor:COLOR_WITH_HEX(0xfbce15)] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _rightButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    _rightButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_rightButton setTitle:PText(@"不开启",nil) forState:UIControlStateNormal];
    [_rightButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_rightButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.5];
    [_rightButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_rightButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_leftButton withOffset:0.5];
    [_rightButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat textHeight = titleSize.height + contentSize.height + 1 + 15;
    if (textHeight > contentHeight*kDefaultViewWidth/iPhone6Width)
    {
        _containerLabelConstraint.constant = textHeight;
        _containerConstraint.constant = (topImageHeight + bottomImageHeight + buttonHeight + 1)*kDefaultViewWidth/iPhone6Width + textHeight;
    }
    
}

- (void)dismiss:(id)sender
{
    [PAuthorizationTipBox dismissAuthorizationTipBox];
}

- (void)requestNotificationsAuthorization:(id)sender
{
    [PAuthorizationTipBox dismissAuthorizationTipBox];
    [PAuthorizationCenter requestNotificationsAuthorization];
    
}

#pragma mark －public－

+ (void)showPAuthorizationTipBox
{
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    PAuthorizationTipBox *appraiseBox = [[PAuthorizationTipBox alloc] initWithFrame:rootWindow.bounds];
    [rootWindow addSubview:appraiseBox];
}

+ (void)dismissAuthorizationTipBox
{
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    for (UIView *view in [rootWindow subviews])
    {
        if ([view isKindOfClass:[PAuthorizationTipBox class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [view removeFromSuperview];
            });
        }
    }
}

@end
