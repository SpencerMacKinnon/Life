//
//  SWMShader.h
//  Life
//
//  Created by Spencer MacKinnon on 2/21/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SWMShader : NSObject {
    GLuint _program, _vertShader, _fragShader;
    NSString *_vertShaderPathname, *_fragShaderPathname;
}

@property NSString *vertShaderPathname, *fragShaderPathname;
@property GLuint program;

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)loadShaders;
- (BOOL)releaseShaders;
- (void)tearDownGL;
- (BOOL)validateProgram:(GLuint)prog;

@end
