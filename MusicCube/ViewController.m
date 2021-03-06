//
//  ViewController.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#include <OpenGLES/ES2/glext.h>

#import "ViewController.h"
#import "HHArcBall.h"
#import "HHShaderManager.h"
#include "ioTGA.h"
#import "HHFrameBufferObject.h"
#import "HHScene.h"
#import "HHGridActor.h"
#import "HHCubeActor.h"
#import "HHSolidShapes.h"
#import "HHCamera.h"


#define BUFFER_OFFSET(i) ((char *)NULL + (i))

void printGLKMatrix(GLKMatrix4* m,NSString* title)
{
   NSLog(@"%@:\n",title);
   NSLog(@"%.2f %.2f %.2f %.2f\n",m->m[0],m->m[4],m->m[8], m->m[12]);
   NSLog(@"%.2f %.2f %.2f %.2f\n",m->m[1],m->m[5],m->m[9], m->m[13]);
   NSLog(@"%.2f %.2f %.2f %.2f\n",m->m[2],m->m[6],m->m[10],m->m[14]);
   NSLog(@"%.2f %.2f %.2f %.2f\n",m->m[3],m->m[7],m->m[11],m->m[15]);
}

GLfloat gCubeVertexData[216] =
{
   // Data layout for each line below is:
   // positionX, positionY, positionZ,     normalX, normalY, normalZ,
   0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
   0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
   0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
   0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
   0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
   0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
   
   0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
   -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
   0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
   0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
   -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
   -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
   
   -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
   -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
   -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
   -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
   -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
   -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
   
   -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
   0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
   -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
   -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
   0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
   0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
   
   0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
   -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
   0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
   0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
   -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
   -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
   
   0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
   -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
   0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
   0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
   -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
   -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@interface ViewController () {
   
   GLKMatrix4 _modelViewProjectionMatrix;
   GLKMatrix3 _normalMatrix;
    GLKMatrix4 _baseModelViewMatrix;
   float _rotation;
   
   GLuint _vertexArray;
   GLuint _vertexBuffer;
   BOOL   _dragging;
   BOOL _doCapture;
   BOOL _useFlatShader;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) HHArcBall   *arcBall;
@property (strong, nonatomic) HHShaderManager *shaderManager;
@property (strong, nonatomic) HHFrameBufferObject *backBuffer;
@property (strong, nonatomic) HHScene *scene;
@property (strong, nonatomic) HHCamera* camera;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation ViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   _doCapture = FALSE;
   _useFlatShader = FALSE;
   self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
   
   if (!self.context) {
      NSLog(@"Failed to create ES context");
   }
   
   GLKView *view = (GLKView *)self.view;
   view.context = self.context;
   view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
   
   [self initGestureRecognizers];
   
   _dragging = FALSE;
   
   self.arcBall = [[ HHArcBall alloc] initWithWidth: self.view.bounds.size.width
                                      andHeight:self.view.bounds.size.height];


    
    [self setupGL];
   
    self.camera = [[HHCamera alloc]init];
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    [self.camera setPerspective:65.0f withApect:aspect nearPlane:0.01f farPlane:100.0f];
    [self.camera translateX:0.0f andY:0.0f andZ:-10.0f];
    
    self.scene = [[HHScene alloc]init];
    [self.scene setup];
    self.scene.shaderManager = self.shaderManager;
    self.scene.camera = self.camera;
}

-(void)initGestureRecognizers
{
   //tap
   self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                initWithTarget:self action:@selector(handleTaps:)];
   self.tapGestureRecognizer.numberOfTouchesRequired = 1;
   self.tapGestureRecognizer.numberOfTouchesRequired =1;
   [self.view addGestureRecognizer:self.tapGestureRecognizer];
}
//deprecated in IOS6, views are never purged in IOS6
/*-(void)viewDidUnload
 {
 super viewDidUnload];
 self.tapGestureRecognizer = nil;
 }*/

- (void)dealloc
{
   [self tearDownGL];
   
   if ([EAGLContext currentContext] == self.context) {
      [EAGLContext setCurrentContext:nil];
   }
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   
   if ([self isViewLoaded] && ([[self view] window] == nil)) {
      self.view = nil;
      
      [self tearDownGL];
      
      if ([EAGLContext currentContext] == self.context) {
         [EAGLContext setCurrentContext:nil];
      }
      self.context = nil;
   }
   
   // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
   [EAGLContext setCurrentContext:self.context];
   
    _shaderManager = [[HHShaderManager alloc] init];
   [_shaderManager loadShaders];
   
   self.effect = [[GLKBaseEffect alloc] init];
   self.effect.light0.enabled = GL_TRUE;
   self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
   
   glEnable(GL_DEPTH_TEST);
   
   glGenVertexArraysOES(1, &_vertexArray);
   glBindVertexArrayOES(_vertexArray);
   
   glGenBuffers(1, &_vertexBuffer);
   glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
   glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
   
   glEnableVertexAttribArray(GLKVertexAttribPosition);
   glVertexAttribPointer(GLKVertexAttribPosition, 3,
                         GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
   glEnableVertexAttribArray(GLKVertexAttribNormal);
   glVertexAttribPointer(GLKVertexAttribNormal, 3,
                         GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
   
   glBindVertexArrayOES(0);
   
   self.backBuffer = [[HHFrameBufferObject alloc]init];
   [self.backBuffer setup];
   
}

- (void)tearDownGL
{
   [EAGLContext setCurrentContext:self.context];
   
   glDeleteBuffers(1, &_vertexBuffer);
   glDeleteVertexArraysOES(1, &_vertexArray);
   
   self.effect = nil;
   self.shaderManager = nil;
   
   [self.backBuffer tearDown];
   self.backBuffer = nil;
   
   self.scene = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
   //update scene
   [self.scene tick];
   
    //assuming aspect does not change
    GLKMatrix4 projectionMatrix =[self.camera getProjection];
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    [self.camera setRotationMatrix:[self.arcBall getRotation]];
   

   _baseModelViewMatrix = [self.camera getMatrix];
   
   // Compute the model view matrix for the object rendered with GLKit
   GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
   modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
   modelViewMatrix = GLKMatrix4Multiply(_baseModelViewMatrix, modelViewMatrix);
   
   self.effect.transform.modelviewMatrix = modelViewMatrix;
   
   // Compute the model view matrix for the object rendered with ES2
   modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
   modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
   modelViewMatrix = GLKMatrix4Multiply(_baseModelViewMatrix, modelViewMatrix);
   
   _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
   
   _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
   
   _rotation += self.timeSinceLastUpdate * 0.5f;
}

-(void)ReadDraw:(BOOL)bFlat
{
 
   
   glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    GLKVector4 color = {0.0f,0.5f,0.0,1.0f};

    GLKMatrix4 mvpCenter = GLKMatrix4Multiply(self.effect.transform.projectionMatrix, _baseModelViewMatrix);
    
   [_shaderManager  useFlatShaderWithMVP:mvpCenter andColor:color ];
   [self.scene render];

   glBindVertexArrayOES(_vertexArray);
   
   // Render the object with GLKit
   [self.effect prepareToDraw];
   
   glDrawArrays(GL_TRIANGLES, 0, 36);
   
   
   
   
   // Render the object again with ES2
   if(bFlat)
   {
      [_shaderManager  useFlatShaderWithMVP:_modelViewProjectionMatrix andColor:color ];
   }
   else
   {
      [_shaderManager  useShaderWithMVP:_modelViewProjectionMatrix andNormalMatrix:_normalMatrix andColor:color];
   }
   
   glDrawArrays(GL_TRIANGLES, 0, 36);

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   if(_doCapture){

      [self.backBuffer use];
      [self ReadDraw:YES];
      [self doCapture ];
      [self.backBuffer restore];
      
      _doCapture = FALSE;
   }

   [self ReadDraw:NO];
}


#pragma mark -  Touches and gestures

-(void)handleTaps:(UITapGestureRecognizer*)sender
{
   //CGPoint pt = [sender locationOfTouch:0 inView:sender.view];
   _useFlatShader = !_useFlatShader;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 
   if(_dragging)
      return;
   
   UITouch* t  = [touches anyObject];
   CGPoint pt = [t locationInView:self.view];
   
   [self.arcBall clickAtPoint:pt];
   
   _dragging = TRUE;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

   if(!_dragging)
      return;
   
   //UITouch* t  = [touches anyObject];
   //CGPoint pt = [t locationInView:self.view];

   _dragging =FALSE;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

   if(!_dragging)
      return;
   
   UITouch* t  = [touches anyObject];
   CGPoint pt = [t locationInView:self.view];
   
   [self.arcBall dragToPoint:pt];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
   //UITouch* t  = [touches anyObject];
   //CGPoint pt = [t locationInView:self.view];

   _dragging =FALSE;
}

#pragma mark - Save to TGA
-(NSString*)generateDBName
{
   
   NSArray* searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
   NSString* path;
   if(searchPath.count == 0)
   {
      return @"";
   }
   
   path = [searchPath objectAtIndex:0];
   
   NSFileManager* fm = [NSFileManager defaultManager];
   
   NSString* dbPath;
   for (int ii=0;ii<99999; ii++) {
      NSString* name = [NSString stringWithFormat:@"%@/capture_%05d.tga",path,ii ];
      if([fm fileExistsAtPath:name] == NO)
      {
         dbPath = [NSString stringWithString:name];
         break;
      }
   }
   
   if([dbPath length]==0)
   {
      dbPath = [NSString stringWithFormat:@"%@/capture_%05d.tga",path, 0 ];
   }
   
   return dbPath;
}

- (IBAction)captureFrontBuffer:(id)sender {
   
   _doCapture = TRUE;

}

-(void)doCapture{
   NSString* capName = [self generateDBName];
   
   const char* name = [capName cStringUsingEncoding:NSASCIIStringEncoding];
   
   NSLog(@"Saving %s\n",name);
   
   if(gltGrabScreenTGA(name)<=0)
   {
      NSLog(@"gltGrabScreenTGA failed saving %@\n",capName);
   }
}
@end
