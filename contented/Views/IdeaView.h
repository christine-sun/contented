//
//  IdeaView.h
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import <UIKit/UIKit.h>
#import "Idea.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IdeaViewDelegate;

@interface IdeaView : UIView

@property (strong, nonatomic) Idea* idea;
@property (nonatomic) CGPoint startPoint;
@property (weak, nonatomic) id<IdeaViewDelegate> delegate;

- (void)setName:(NSString*)title;
- (void)didTouchIdea:(UITapGestureRecognizer*)sender;

@end

@protocol IdeaViewDelegate
- (void)ideaView:(IdeaView *) ideaView didTap: (Idea *)idea;
@end

NS_ASSUME_NONNULL_END
