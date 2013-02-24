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
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    _aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), _aspect, 0.1f, 100.0f);
    
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
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    GLKVector3 topLeft, bottomRight;
    [self recalculateScreenBoundariesForGridWithProjectionMatrix:_projectionMatrix withTopLeft:&topLeft withBototmRight:&bottomRight];
    _grid = [[SWMGrid alloc] initWithTopLeft:topLeft withBottomRight:bottomRight];
    [_grid setupGL];
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    self.effect = nil;
    
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    [_grid tearDownGL];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    _aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), _aspect, 0.1f, 100.0f);
    
    for (NSArray *row in [_grid tiles]) {
        for (SWMTileSpace *tileSpace in row) {
            
            GLKMatrix4 modelViewMatrix = [[tileSpace tile] modelViewMatrix];
            
            GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
            GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(_projectionMatrix, modelViewMatrix);
            
            [[tileSpace tile] setNormalMatrix:normalMatrix];
            [[tileSpace tile] setModelViewProjectionMatrix:modelViewProjectionMatrix];
        }
    }
    
    [self recalculateScreenBoundariesForGridWithProjectionMatrix:_projectionMatrix];
    [_grid determineNextIteration];
}



- (void)recalculateScreenBoundariesForGridWithProjectionMatrix:(GLKMatrix4)projectionMatrix withTopLeft:(GLKVector3 *)topLeft withBototmRight:(GLKVector3 *)bottomRight{
    
    float viewPortOriginX = self.view.bounds.origin.x;
    float viewPortOriginY = self.view.bounds.origin.y;
    float viewPortWidth = self.view.bounds.size.width;
    float viewPortHeight = self.view.bounds.size.height;
    
    GLKVector4 viewPort = GLKVector4Make(viewPortOriginX, viewPortOriginY, viewPortWidth, viewPortHeight);
    
    GLKMatrix4 identityMatrix = GLKMatrix4Make(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    
    GLKVector3 topLeftScreenCoordinate = [self worldSpacePixelLocation:viewPortOriginX withWindowCoordinateY:viewPortOriginY withViewPort:viewPort withModelViewMatrix:identityMatrix withProjectionMatrix:projectionMatrix];
    
    GLKVector3 bottomRightScreenCoordinate = [self worldSpacePixelLocation:viewPortWidth withWindowCoordinateY:viewPortHeight withViewPort:viewPort withModelViewMatrix:identityMatrix withProjectionMatrix:projectionMatrix];
    
    *topLeft = topLeftScreenCoordinate;
    *bottomRight = bottomRightScreenCoordinate;
}

- (void)recalculateScreenBoundariesForGridWithProjectionMatrix:(GLKMatrix4)projectionMatrix {
    
    GLKVector3 topLeft, bottomRight;
    [self recalculateScreenBoundariesForGridWithProjectionMatrix:projectionMatrix withTopLeft:&topLeft withBototmRight:&bottomRight];
    
    [_grid setTopLeftBoundary:topLeft];
    [_grid setBottomRightBoundary:bottomRight];
}

- (GLKVector3)worldSpacePixelLocation:(CGFloat)windowCoordinateX withWindowCoordinateY:(CGFloat)windowCoordinateY withViewPort:(GLKVector4) viewPort withModelViewMatrix:(GLKMatrix4) modelViewMatrix withProjectionMatrix:(GLKMatrix4) projectionMatrix {
    
    float winX = windowCoordinateX;
    float winY = viewPort.w - windowCoordinateY; //Invert this as OpenGL flips the Y coordinate
    float winZ = 0.0f;
    
    float posX, posY, posZ;
    
    glReadPixels(windowCoordinateX, (int)winY, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &winZ);// Not used, will always be 0
    
    // We only need to call this once, with the near view frustum (-0.1 on the frustum corresponding to winZ = 0.0).
    // This is because we are basically treating our 3D world as a 2D one. If it was a real 3D implementation,
    // we would have to call unProject again, with winZ = 1.0f. This would allow us to create a ray, and then
    // intersect anything along that ray.
    [self unProjectWith:winX winY:winY winZ:winZ modelViewMatrix:modelViewMatrix projectionMatrix:projectionMatrix viewPort:viewPort posX:&posX posY:&posY posZ:&posZ];
    
    return GLKVector3Make(posX, posY, posZ);
}

- (BOOL)unProjectWith:(float)winX winY:(float)winY winZ:(float)winZ modelViewMatrix:(GLKMatrix4)modelViewMatrix projectionMatrix:(GLKMatrix4)projectionMatrix viewPort:(GLKVector4)viewPort posX:(float *)posX posY:(float *)posY posZ:(float *)posZ {
    
    bool isInvertible = false;
    
    GLKMatrix4 modelViewProjectionMatrixInverted = GLKMatrix4Invert(GLKMatrix4Multiply(projectionMatrix, modelViewMatrix), &isInvertible);
    
    if (!isInvertible) // Double check that we sucessfully inverted the matrix
        return false;
    
    GLKVector4 inWindowCoordinates = GLKVector4Make(winX, winY, winZ, 1.0f);
    
    inWindowCoordinates.x = (inWindowCoordinates.x - viewPort.x) / viewPort.z; // Convert our point to a range between 0..1
    inWindowCoordinates.y = (inWindowCoordinates.y - viewPort.y) / viewPort.w;
    
    inWindowCoordinates.x = inWindowCoordinates.x * 2.0f - 1.0f; // Now move it to a range of -1..1; the view coordinates
    inWindowCoordinates.y = inWindowCoordinates.y * 2.0f - 1.0f;
    inWindowCoordinates.z = inWindowCoordinates.z * 2.0f - 1.0f;
    
    GLKVector4 outWorldCoordinates = GLKMatrix4MultiplyVector4(modelViewProjectionMatrixInverted, inWindowCoordinates);
    
    if (outWorldCoordinates.w == 0.0) // Ensure the determinate is not zero
        return false;
    
    float invertedW = 1.0f / outWorldCoordinates.w; // Divide by W to get into world space. Inversion and multiplication is faster than division.
    
    outWorldCoordinates.x *= invertedW;
    outWorldCoordinates.y *= invertedW;
    outWorldCoordinates.z *= invertedW;
    
    *posX = outWorldCoordinates.x;
    *posY = outWorldCoordinates.y;
    *posZ = outWorldCoordinates.z;
    
    return true;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    [_grid glkView:view drawInRect:rect];
}

@end
