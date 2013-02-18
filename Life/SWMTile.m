//
//  SWMTile.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMTile.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation SWMTile

const int TOTAL_VERTICES = 12;

@synthesize diffuseLightColour;
@synthesize colourIndex;

- (id)init{
    
    self = [super init];
    if (self) {
        
        _vertex = (GLKVector3 *)malloc(TOTAL_VERTICES * sizeof(GLKVector3));
        
        GLKVector4 diffuseLightColourBlack = GLKVector4Make(0.0, 0.0, 0.0, 0.0);
        GLKMatrix4 mvMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
        
        GLfloat squareVertexData [36]= {
            // Data layout for each line below is:
            // positionX, positionY, positionZ,     normalX, normalY, normalZ,
            
            0.0015f, 0.0015f, -0.1f,          0.0f, 0.0f, 1.0f,
            -0.0015f, 0.0015f, -0.1f,         0.0f, 0.0f, 1.0f,
            0.0015f, -0.0015f, -0.1f,         0.0f, 0.0f, 1.0f,
            0.0015f, -0.0015f, -0.1f,         0.0f, 0.0f, 1.0f,
            -0.0015f, 0.0015f, -0.1f,         0.0f, 0.0f, 1.0f,
            -0.0015f, -0.0015f, -0.1f,        0.0f, 0.0f, 1.0f
            
        };
        
        numberOfVertices = 0;
        
        for (numberOfFloatsInVertices = 0; numberOfVertices < TOTAL_VERTICES; numberOfVertices++, numberOfFloatsInVertices+=3) {
            GLKVector3 vector = GLKVector3Make(squareVertexData[numberOfFloatsInVertices], squareVertexData[numberOfFloatsInVertices+1],
                                               squareVertexData[numberOfFloatsInVertices+2]);
            _vertex[numberOfVertices] = vector;
        }
        
        [self setDiffuseLightColour:diffuseLightColourBlack];
        [self setModelViewMatrix: mvMatrix];
        
        // Create reference vertex shader path
        vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
        
        // Create reference fragment shader path
        fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
        
    }
    return self;
}

- (id)initWith:(GLKMatrix4)mvMatrix andColour:(GLKVector4)colour{
    self = [self init];
    if (self) {
        [self setModelViewMatrix:mvMatrix];
        [self setDiffuseLightColour:colour];
    }
    
    return self;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glUniform4f(colourIndex, diffuseLightColour.x, diffuseLightColour.y, diffuseLightColour.z, diffuseLightColour.w);
    
    glDrawArrays(GL_TRIANGLES, 0, numberOfFloatsInVertices);
}

- (BOOL)loadShaders {
    
    [super loadShaders];
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Compile vertex shader.
    if (![self compileShader:&_vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Compile fragment shader.
    if (![self compileShader:&_fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, _vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, _fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (_vertShader) {
            glDeleteShader(_vertShader);
            _vertShader = 0;
        }
        if (_fragShader) {
            glDeleteShader(_fragShader);
            _fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    colourIndex = glGetUniformLocation(_program, "diffuseColour");
    
    // Release vertex and fragment shaders.
    if (_vertShader) {
        glDetachShader(_program, _vertShader);
        glDeleteShader(_vertShader);
    }
    if (_fragShader) {
        glDetachShader(_program, _fragShader);
        glDeleteShader(_fragShader);
    }
    
    return YES;
}

- (BOOL)setupGL {
    if ([super setupGL]) {
        
        [self loadShaders];
        
        glEnable(GL_DEPTH_TEST);
        
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        
        float vertexDataFloat[numberOfFloatsInVertices];
        NSMutableData *vertexDataBytes = [self vertexData];
        
        [vertexDataBytes getBytes:vertexDataFloat length:sizeof(vertexDataFloat)];
        
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexDataFloat), vertexDataFloat, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
        
        glBindVertexArrayOES(0);
        
        return YES;
    }
    
    return NO;
}

- (void)tearDownGL {
    glDeleteBuffers(1, &_vertexBuffer);
    
    if (_program){
        glDeleteProgram(_program);
        _program = 0;
    }
}

@end
