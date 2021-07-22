//
//  Board.h
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Board : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *items;

@end

NS_ASSUME_NONNULL_END
