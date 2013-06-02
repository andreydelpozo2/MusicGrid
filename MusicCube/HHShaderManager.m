//
//  HHShaderManager
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/1/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHShaderManager.h"
#include <limits.h>

// Uniform index.
enum
{
   UNIFORM_MODELVIEWPROJECTION_MATRIX,
   UNIFORM_NORMAL_MATRIX,
   NUM_UNIFORMS
};

enum{
   SAMPLE_SHADER,
   FLAT_SHADER,
   MAX_SHADERS
};

@interface HHShaderManager()
{
   GLuint _programs[MAX_SHADERS];
}
- (BOOL)loadProgram:(GLuint*) programId fromFile:(NSString*)name;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation HHShaderManager

#pragma mark -  Boilerplate OpenGLES2 code
- (BOOL)loadProgram:(GLuint*) programId fromFile:(NSString*)name
{

   GLuint vertShader, fragShader;
   NSString *vertShaderPathname, *fragShaderPathname;
   
   // Create shader program.
   GLuint pid = glCreateProgram();
   
   // Create and compile vertex shader.
   vertShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
   if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
      NSLog(@"Failed to compile vertex shader");
      return NO;
   }
   
   // Create and compile fragment shader.
   fragShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
   if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
      NSLog(@"Failed to compile fragment shader");
      return NO;
   }

   glAttachShader(pid, vertShader);
   
   // Attach fragment shader to program.
   glAttachShader(pid, fragShader);
   
   // Bind attribute locations.
   // This needs to be done prior to linking.
   glBindAttribLocation(pid, GLKVertexAttribPosition, "position");
   glBindAttribLocation(pid, GLKVertexAttribNormal, "normal");
   
   // Link program.
   if (![self linkProgram:pid]) {
      NSLog(@"Failed to link program: %@", name);
      
      if (vertShader) {
         glDeleteShader(vertShader);
         vertShader = 0;
      }
      if (fragShader) {
         glDeleteShader(fragShader);
         fragShader = 0;
      }
      if (pid) {
         glDeleteProgram(pid);
      }
      
      return NO;
   }
   
   
   // Release vertex and fragment shaders.
   if (vertShader) {
      glDetachShader(pid, vertShader);
      glDeleteShader(vertShader);
   }
   if (fragShader) {
      glDetachShader(pid, fragShader);
      glDeleteShader(fragShader);
   }
   
   *programId = pid;
   return YES;
}

- (BOOL)loadShaders
{
   GLuint progId =0;
   if([self loadProgram:&progId fromFile:@"Shader"])
   {
      _programs[SAMPLE_SHADER] = progId;
   }
   
   if([self loadProgram:&progId fromFile:@"flatShader"])
   {
      _programs[FLAT_SHADER] = progId;
   }

   return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
   GLint status;
   const GLchar *source;
   
   source = (GLchar *)[[NSString stringWithContentsOfFile:file
                                                 encoding:NSUTF8StringEncoding error:nil] UTF8String];
   if (!source) {
      NSLog(@"Failed to load vertex shader");
      return NO;
   }
   
   *shader = glCreateShader(type);
   glShaderSource(*shader, 1, &source, NULL);
   glCompileShader(*shader);
   
#if defined(DEBUG)
   GLint logLength;
   glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
   if (logLength > 0) {
      GLchar *log = (GLchar *)malloc(logLength);
      glGetShaderInfoLog(*shader, logLength, &logLength, log);
      NSLog(@"Shader compile log:\n%s", log);
      free(log);
   }
#endif
   
   glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
   if (status == 0) {
      glDeleteShader(*shader);
      return NO;
   }
   
   return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
   GLint status;
   glLinkProgram(prog);
   
#if defined(DEBUG)
   GLint logLength;
   glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
   if (logLength > 0) {
      GLchar *log = (GLchar *)malloc(logLength);
      glGetProgramInfoLog(prog, logLength, &logLength, log);
      NSLog(@"Program link log:\n%s", log);
      free(log);
   }
#endif
   
   glGetProgramiv(prog, GL_LINK_STATUS, &status);
   if (status == 0) {
      return NO;
   }
   
   return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
   GLint logLength, status;
   
   glValidateProgram(prog);
   glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
   if (logLength > 0) {
      GLchar *log = (GLchar *)malloc(logLength);
      glGetProgramInfoLog(prog, logLength, &logLength, log);
      NSLog(@"Program validate log:\n%s", log);
      free(log);
   }
   
   glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
   if (status == 0) {
      return NO;
   }
   
   return YES;
}

#pragma mark -  Resource management
-(void)dealloc
{
   for(int ii=0;ii<MAX_SHADERS;ii++)
   {
      if (_programs[ii]) {
         glDeleteProgram(_programs[ii]);
         _programs[ii] = 0;
      }
   }
}

#pragma mark -  External interface

-(void)useShaderWithMVP:(GLKMatrix4)mvp andNormalMatrix:(GLKMatrix3)normalMatrix andColor:(GLKVector4)color;
{
   GLuint prog = _programs[SAMPLE_SHADER];
   
   glUseProgram(prog);
   
   GLint mvpU = glGetUniformLocation(prog, "modelViewProjectionMatrix");
   GLint nmU = glGetUniformLocation(prog, "normalMatrix");
   GLint iColor = glGetUniformLocation(prog, "vColor");
   
   glUniformMatrix4fv(mvpU, 1, 0, mvp.m);
   glUniformMatrix3fv(nmU, 1, 0, normalMatrix.m);
   glUniform4fv(iColor, 1, color.v);
}

-(void)useFlatShaderWithMVP:(GLKMatrix4)mvp andColor:(GLKVector4)color
{
   GLuint prog = _programs[FLAT_SHADER];
   
   glUseProgram(prog);
   
   GLint mvpU = glGetUniformLocation(prog, "mvpMatrix");
   glUniformMatrix4fv(mvpU, 1, 0, mvp.m);
   
   GLint iColor = glGetUniformLocation(prog, "vColor");
   glUniform4fv(iColor, 1, color.v);
   
   
   
   
}
@end
