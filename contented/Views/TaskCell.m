//
//  TaskCell.m
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import "TaskCell.h"

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTask:(Task *)task {
    _task = task;
    
    self.titleLabel.text = self.task.title;
    
    // configure image views
//    self.imageView1.image = nil;
//    self.imageView2.image = nil;
//    self.imageView3.image = nil;
//    self.imageView4.image = nil;
    
    // TODO: traverse the dictionary and set the image based on 0 or 1 
}

@end
