//
//  HHFrameBufferObject.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHFrameBufferObject : NSObject
-(void)setup;
-(void)tearDown;
-(void)use;
-(void)restore;
@end
