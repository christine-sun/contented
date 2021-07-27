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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.menuItemLabel.backgroundColor = [UIColor colorWithRed:81.0/255 green:168.0/255 blue:101.0/255 alpha:1];
    }
    else {
        self.menuItemLabel.backgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
}

@end
