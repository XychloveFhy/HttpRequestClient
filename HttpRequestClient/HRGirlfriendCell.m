//
//  HRGirlfriendCell.m
//  HttpRequestClient
//
//  Created by 张雁军 on 22/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRGirlfriendCell.h"

@implementation HRGirlfriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        _avatar = [[UIImageView alloc] init];
        _avatar.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_avatar];
        _avatar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_avatar(90)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_avatar]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
