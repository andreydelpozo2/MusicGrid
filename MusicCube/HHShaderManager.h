//
//  ShaderManager.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/1/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface HHShaderManager : NSObject
@property (strong, nonatomic) GLKBaseEffect *effect;

- (BOOL)loadShaders;
-(void)useShaderWithMVP:(GLKMatrix4)mvp andNormalMatrix:(GLKMatrix3)normalMatrix andColor:(GLKVector4)color;
-(void)useFlatShaderWithMVP:(GLKMatrix4)mvp andColor:(GLKVector4)color;
@end
