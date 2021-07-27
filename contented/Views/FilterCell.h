//
//  FilterCell.h
//  contented
//
//  Created by Christine Sun on 7/27/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setTitle:(NSString*)title isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
