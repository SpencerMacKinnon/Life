//
//  SWMViewController.m
//  Life
//
//  Created by Spencer MacKinnon on 1/30/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMViewController.h"

@interface SWMViewController () {
    
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation SWMViewController{
    GLuint _vertexArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWMTile *firstTile = [[SWMTile alloc] init];
    SWMTile *secondTile = [[SWMTile alloc] init2];
    
    models = [[NSMutableArray alloc] initWithObjects:firstTile, secondTile, nil];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

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
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    for (SWMTile *tile in models) {
        
        [tile setupGL];
    }
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    self.effect = nil;
    
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    for (SWMTile *tile in models) {
        [tile tearDownGL];
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    for (SWMTile *tile in models) {
        GLKMatrix4 modelViewMatrix = [tile modelViewMatrix];
        
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
        GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
        
        [tile setNormalMatrix:normalMatrix];
        [tile setModelViewProjectionMatrix:modelViewProjectionMatrix];
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    for (SWMTile *tile in models) {
        
        [tile glkView:view drawInRect:rect];
    }
}

@end
