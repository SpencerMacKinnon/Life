//
//  SWMModel.h
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SWMModel : NSObject
{
    GLKMatrix4 _modelViewMatrix, _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLKVector3 *_vertex;
    
    GLuint _program, _vertexBuffer, _vertShader, _fragShader;    
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
    
    NSMutableData *vertexData;
    NSString *vertShaderPathname, *fragShaderPathname;
    unsigned long numberOfFloatsInVertices, numberOfVertices, sizeOfVerticies;
}

@property GLKMatrix4 modelViewMatrix, modelViewProjectionMatrix;
@property GLKMatrix3 normalMatrix;
//@property GLuint program, vertShader, fragShader;
//@property GLuint *vertexArray, *vertexBuffer;
@property GLuint NUM_UNIFORMS, UNIFORM_MODELVIEWPROJECTION_MATRIX, UNIFORM_NORMAL_MATRIX;
@property NSString *vertShaderPathname, *fragShaderPathname;
@property unsigned long numberOfFloatsInVertices, numberOfVertices, sizeOfVerticies;

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)loadShaders;
- (BOOL)validateProgram:(GLuint)prog;
- (NSMutableData*)vertexData;
- (BOOL)setupGL;
- (void)tearDownGL;

@end
