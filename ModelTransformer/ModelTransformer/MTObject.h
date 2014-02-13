//
//  MTObject.h
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MTObject : NSObject

- (id)initWithObject:(id)object entity:(NSEntityDescription *)entity;

@property (nonatomic, readonly) NSEntityDescription *entity;

@end
