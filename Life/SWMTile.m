//
//  SWMTile.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMTile.h"

@implementation SWMTile

@synthesize diffuseLightColour;
@synthesize colourIndex;

- (id)init{
    
    self = [super init];
    if (self) {
        GLKVector4 diffuseLightColourBlack = GLKVector4Make(0.0, 0.0, 0.0, 0.0);
        GLKMatrix4 mvMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
        
        [self setDiffuseLightColour:diffuseLightColourBlack];
        [self setModelViewMatrix: mvMatrix];
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

- (BOOL)loadShaders{
    // Override point for custom shader attributes.
    if ([super loadShaders]) {
        colourIndex = glGetUniformLocation([_shader program], "diffuseColour");
    }
    // TODO: Release on teardown
    [super releaseShaders];
    return YES;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    // TODO: Refactor this to call only the models draw call, perhaps using a property bag?
    [super glkView:view drawInRect:rect];
    
    glUniform4f(colourIndex, diffuseLightColour.x, diffuseLightColour.y, diffuseLightColour.z, diffuseLightColour.w);
}

@end
