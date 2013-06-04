//
//  HHSolidShapes.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHBatch.h"

@interface HHSolidShapes : NSObject
+(HHBatch*)makeCubeWithSide:(float)sideLen;
@end
