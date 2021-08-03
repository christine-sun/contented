//
//  FilterCell.m
//  contented
//
//  Created by Christine Sun on 7/27/21.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString*)title isSelected:(BOOL)isSelected {
    self.titleLabel.text = title;
    [self.titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:25]];
    if (isSelected) {
        self.titleLabel.textColor = [UIColor systemTealColor];
    } else {
        self.titleLabel.textColor = [UIColor systemGray2Color];
    }
}


@end
