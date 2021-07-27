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
        self.backgroundColor = [UIColor systemTealColor];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
