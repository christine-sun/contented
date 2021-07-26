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

- (void)setName:(NSString*)title;
- (void)setTrashView:trash;

@end

NS_ASSUME_NONNULL_END
