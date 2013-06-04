//
//  HHActor.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHBatch.h"

@interface HHActor : NSObject
@property (strong,nonatomic) HHBatch* mesh;
-(void)render;
@end
