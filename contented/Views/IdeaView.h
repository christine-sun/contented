//
//  IdeaView.h
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import <UIKit/UIKit.h>
#import "Idea.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdeaView : UIView

@property (strong, nonatomic) Idea* idea;
@property (nonatomic) CGPoint startPoint;

- (void)setName:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
