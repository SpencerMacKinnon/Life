//
//  SWMModel.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMModel.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation SWMModel

@synthesize modelViewMatrix = _modelViewMatrix;
@synthesize modelViewProjectionMatrix = _modelViewProjectionMatrix;
@synthesize normalMatrix = _normalMatrix;
@synthesize vertShaderPathname, fragShaderPathname;
@synthesize numberOfFloatsInVertices, numberOfVertices, sizeOfVerticies;

- (id)init{
    self = [super init];
    if (self){
        numberOfVertices = 0;
    }
    
    return self;
}

- (NSMutableData*)vertexData{
    
    int verticeByteSize = sizeof(_vertex);
    
    NSMutableData *vertexMutableData = [NSMutableData dataWithCapacity:verticeByteSize];
    
    for (int i=0; i < numberOfVertices; i++) {
        [vertexMutableData appendBytes:&_vertex[i].x length:sizeof(float)];
        [vertexMutableData appendBytes:&_vertex[i].y length:sizeof(float)];
        [vertexMutableData appendBytes:&_vertex[i].z length:sizeof(float)];
    }
    
    return vertexMutableData;
}

- (unsigned long)sizeOfVertices {
    
    return sizeof(_vertex);
}

- (BOOL)loadShaders{
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
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

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    return;
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

- (BOOL)setupGL{
    return YES;
}

- (void)tearDownGL{
    return;
}

@end
