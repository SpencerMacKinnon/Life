//
//  SWMModel.h
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include "SWMVertexArray.h"
#include "SWMShader.h"

@interface SWMModel : NSObject
{
    GLKMatrix4 _modelViewMatrix, _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    
    SWMVertexArray *_vertexArray;
    SWMShader *_shader;
    
    // Uniform index.
    enum
    {
        UNIFORM_MODELVIEWPROJECTION_MATRIX,
        UNIFORM_NORMAL_MATRIX,
        NUM_UNIFORMS
    };
    GLint uniforms[NUM_UNIFORMS];
    
    // Attribute index.
    enum
    {
        ATTRIB_VERTEX,
        ATTRIB_NORMAL,
        NUM_ATTRIBUTES
    };
    
    
}

@property GLKMatrix4 modelViewMatrix, modelViewProjectionMatrix;
@property GLKMatrix3 normalMatrix;
@property SWMVertexArray *vertexArray;
@property SWMShader *shader;

- (id)initWithShader:(SWMShader *)shader;
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
- (BOOL)loadShaders;
- (unsigned long)numberOfFloatsInVertices;
- (int)numberOfVertices;
- (BOOL)releaseShaders;
- (unsigned long)sizeOfVertices;
- (void)tearDownGL;
- (NSMutableData *)vertexData;

@end
