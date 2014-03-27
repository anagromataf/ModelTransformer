//
//  MTArrayTransformer.h
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MTArrayTransformer : NSArray

#pragma mark Life-cycle
- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity userInfo:(NSDictionary *)userInfo;
- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity userInfo:(NSDictionary *)userInfo class:(Class)_class;

#pragma mark Entity Description
@property (nonatomic, readonly) NSEntityDescription *entity;

#pragma mark Transform Object - Overwrite in Subclass
- (id)transformedObjectAtIndex:(NSUInteger)index ofArray:(NSArray *)array userInfo:(NSDictionary *)userInfo;
- (NSUInteger)transformedCountOfArray:(NSArray *)array userInfo:(NSDictionary *)userInfo;

@end
