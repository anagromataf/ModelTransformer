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

- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity;

@property (nonatomic, readonly) NSEntityDescription *entity;

@end
