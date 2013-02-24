//
//  SWMModel.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMModel.h"

@implementation SWMModel

@synthesize modelViewMatrix = _modelViewMatrix;
@synthesize modelViewProjectionMatrix = _modelViewProjectionMatrix;
@synthesize normalMatrix = _normalMatrix;
@synthesize vertexArray = _vertexArray;
@synthesize shader = _shader;

- (id)initWithShader:(SWMShader *)shader{
    self = [super init];
    if (self){
        _shader = shader;
    }
    
    return self;
}

- (NSMutableData *)vertexData{
    return [_vertexArray vertexData];
}

- (unsigned long)sizeOfVertices {
    return [_vertexArray sizeOfVertices];
}

- (unsigned long)numberOfFloatsInVertices {
    return [_vertexArray numberOfFloatsInVertices];
}

- (int)numberOfVertices {
    return [_vertexArray numberOfVertices];
}

- (BOOL)loadShaders{
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation([_shader program], "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation([_shader program], "normalMatrix");
    return YES;
}

- (BOOL)releaseShaders{
    return [_shader releaseShaders];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glUseProgram([_shader program]);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
}

- (void)tearDownGL{
    [_shader tearDownGL];
}

@end
