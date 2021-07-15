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
    
    NSArray *imageViews = [NSArray array];
    imageViews = [imageViews arrayByAddingObject:self.imageView1];
    imageViews = [imageViews arrayByAddingObject:self.imageView2];
    imageViews = [imageViews arrayByAddingObject:self.imageView3];
    imageViews = [imageViews arrayByAddingObject:self.imageView4];
    __block int index = 0;
    
    // Display platform icons depending on user selection for this task
    NSDictionary *dict = self.task.platforms;
    [dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        // key is social media platform, obj is TRUE or FALSE
        NSString *thisValue = obj;
        NSInteger valueInt = [thisValue integerValue];
        if (valueInt == 0) {
            UIImage *image = [self findImage:key];
            UIImageView *currentView = [imageViews objectAtIndex:index];
            [currentView setImage:image];
            index++;
        }
    }];
    
    // Set remaining image view slots to nil
    for (int i = index; i < 4; i++) {
        UIImageView *currentView = imageViews[i];
        currentView.image = nil;
    }
}

- (UIImage*)findImage:(NSString*)platform  {
    if ([platform isEqualToString:@"YouTube"])
        return [UIImage imageNamed:@"youtube_icon"];
    else if ([platform isEqualToString:@"Instagram"])
        return [UIImage imageNamed:@"instagram_icon"];
    else if ([platform isEqualToString:@"Snapchat"])
        return [UIImage imageNamed:@"snapchat_icon"];
    else if ([platform isEqualToString:@"TikTok"])
        return [UIImage imageNamed:@"tiktok_icon"];
    else if ([platform isEqualToString:@"Twitter"])
        return [UIImage imageNamed:@"twitter_icon"];
    else return nil;
}

@end
