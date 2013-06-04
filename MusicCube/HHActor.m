//
//  HHActor.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHActor.h"

@implementation HHActor
@synthesize mesh;
-(void)render
{
    [self.mesh draw];
}
@end
