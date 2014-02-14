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

#pragma mark Entity Description
@property (nonatomic, readonly) NSEntityDescription *entity;

#pragma mark Transform Object
- (id)transformObject:(id)object;

@end
