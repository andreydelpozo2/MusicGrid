//
//  ViewController.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@end
