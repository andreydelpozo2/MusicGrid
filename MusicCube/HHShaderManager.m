//
//  HHShaderManager
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/1/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHShaderManager.h"


// Uniform index.
enum
{
   UNIFORM_MODELVIEWPROJECTION_MATRIX,
   UNIFORM_NORMAL_MATRIX,
   NUM_UNIFORMS
};


@interface HHShaderManager()
{
   GLuint _program;
   GLint _uniforms[NUM_UNIFORMS];
}
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation HHShaderManager

#pragma mark -  Boilerplate OpenGLES2 code
- (BOOL)loadShaders
{
   GLuint vertShader, fragShader;
   NSString *vertShaderPathname, *fragShaderPathname;
   
   // Create shader program.
   _program = glCreateProgram();
   
   // Create and compile vertex shader.
   vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
   if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
      NSLog(@"Failed to compile vertex shader");
      return NO;
   }
   
   // Create and compile fragment shader.
   fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
   if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
      NSLog(@"Failed to compile fragment shader");
      return NO;
   }
   
   // Attach vertex shader to program.
   glAttachShader(_program, vertShader);
   
   // Attach fragment shader to program.
   glAttachShader(_program, fragShader);
   
   // Bind attribute locations.
   // This needs to be done prior to linking.
   glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
   glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
   
   // Link program.
   if (![self linkProgram:_program]) {
      NSLog(@"Failed to link program: %d", _program);
      
      if (vertShader) {
         glDeleteShader(vertShader);
         vertShader = 0;
      }
      if (fragShader) {
         glDeleteShader(fragShader);
         fragShader = 0;
      }
      if (_program) {
         glDeleteProgram(_program);
         _program = 0;
      }
      
      return NO;
   }
   
   // Get uniform locations.
   _uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] =
   glGetUniformLocation(_program, "modelViewProjectionMatrix");
   _uniforms[UNIFORM_NORMAL_MATRIX] =
   glGetUniformLocation(_program, "normalMatrix");
   
   // Release vertex and fragment shaders.
   if (vertShader) {
      glDetachShader(_program, vertShader);
      glDeleteShader(vertShader);
   }
   if (fragShader) {
      glDetachShader(_program, fragShader);
      glDeleteShader(fragShader);
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
   if (_program) {
      glDeleteProgram(_program);
      _program = 0;
   }
}

#pragma mark -  External interface
- (GLuint)getProgram
{
   return _program;
}

-(void)useShaderWithMVP:(GLKMatrix4)mvp andNormalMatrix:(GLKMatrix3)normalMatrix;
{
   glUseProgram(_program);
   glUniformMatrix4fv(_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, mvp.m);
   glUniformMatrix3fv(_uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
}
@end
