//
//  MTArray.h
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MTArray : NSArray

#pragma mark Life-cycle
- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity;
- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity class:(Class)_class;

#pragma mark Entity Description
@property (nonatomic, readonly) NSEntityDescription *entity;

#pragma mark Transform Object - Overwrite in Subclass
- (id)transformedObjectAtIndex:(NSUInteger)index ofArray:(NSArray *)array;
- (NSUInteger)transformedCountOfArray:(NSArray *)array;

@end
