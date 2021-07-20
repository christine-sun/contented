//
//  Video.h
//  contented
//
//  Created by Christine Sun on 7/20/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Video : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *vidID;
@property (nonatomic) int views;
@property (strong, nonatomic) NSString *publishedAt;

@end

NS_ASSUME_NONNULL_END
