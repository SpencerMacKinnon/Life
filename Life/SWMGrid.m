//
//  SWMGrid.m
//  Life
//
//  Created by Spencer MacKinnon on 2/16/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMGrid.h"
#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation SWMGrid

@synthesize tiles = _tiles;
@synthesize topLeftBoundary = _topLeftBoundary;
@synthesize bottomRightBoundary = _bottomRightBoundary;

float const TILE_SIDE_LENGTH = 0.003f;

- (id)initWithTopLeft:(GLKVector3)topLeft withBottomRight:(GLKVector3)bottomRight{
    
    self = [super init];
    if (self) {
        [self constructBoundariesWithTopLeft:topLeft andBottomRight:bottomRight];
        if (_numberOfTilesWidth == 0 || _numberOfTilesHeight == 0) {
            return NULL;
        }
        _va = [[SWMVertexArray alloc] init];
        _shader = [[SWMShader alloc] init];
        _tiles = [[NSMutableArray alloc] init];
        
        for (int i=0; i < _numberOfTilesHeight; i++) {
            
            NSMutableArray *row = [[NSMutableArray alloc] init];
            for (int j=0; j < _numberOfTilesWidth; j++) {
                SWMTile *tile = [[SWMTile alloc] initWithShader:_shader];
                SWMTileSpace *tileSpace = [[SWMTileSpace alloc] initWithTile:tile];
                
                if (arc4random() % 4 == 0) {
                    [tileSpace setIsActive:true];
                }
                
                [tileSpace setRow:i];
                [tileSpace setColumn:j];
                [[tileSpace tile] setModelViewMatrix:[self generateModelViewMatrixForRow:j andColumn:i]];
                [[tileSpace tile] setVertexArray:_va];
                [[tileSpace tile] loadShaders];
                
                [row addObject:tileSpace];
            }
            [_tiles addObject:row];
        }
        
        //[[[[_tiles objectAtIndex:0] objectAtIndex:0] tile] setDiffuseLightColour:GLKVector4Make(1.0f, 0.0f, 0.0f, 0.0f)];
        //[[[[_tiles objectAtIndex:42] objectAtIndex:23] tile] setDiffuseLightColour:GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f)];
    }
    
    return self;
}

- (GLKMatrix4)generateModelViewMatrixForRow:(int)row andColumn:(int)column{
    
    float x = row * TILE_SIDE_LENGTH;
    x = _topLeftBoundary.x + x;
    
    float y = column * TILE_SIDE_LENGTH;
    y = _topLeftBoundary.y - y;
    
    return GLKMatrix4MakeTranslation(x, y, 0.0f);
}

- (bool)testWithinGridSpace:(CGPoint)point{
    
    return true;
}

- (void)constructBoundariesWithTopLeft:(GLKVector3)topLeft andBottomRight:(GLKVector3)bottomRight{
    _topLeftBoundary = topLeft;
    _bottomRightBoundary = bottomRight;
    
    _width = _bottomRightBoundary.x - _topLeftBoundary.x;
    _height = _topLeftBoundary.y - _bottomRightBoundary.y;
    
    // Add one here so we don't have a border around the edge
    // TODO: Dynamically set side length to prevent a remainder
    _numberOfTilesWidth = (_width / TILE_SIDE_LENGTH) + 1;
    _numberOfTilesHeight = (_height / TILE_SIDE_LENGTH) + 1;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    GLint offset = 0;
    
    for (NSArray *row in _tiles) {
        for (SWMTileSpace *tileSpace in row) {
            int numberOfVertices = [[tileSpace tile] numberOfVertices];
            if ([tileSpace isActive]) {
                [[tileSpace tile] glkView:view drawInRect:rect];
                glDrawArrays(GL_TRIANGLES, offset, numberOfVertices);
            }
            offset += numberOfVertices;
        }
    }
}

-(void)setupGL{
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    unsigned int totalDataSize = 0;
    NSMutableData *vertexData = [[NSMutableData alloc] init];
    
    for (NSArray *row in _tiles) {
        for (SWMTileSpace *tileSpace in row) {
            SWMTile *tile = [tileSpace tile];
            totalDataSize += [tile sizeOfVertices];
            [vertexData appendBytes:[[tile vertexData] mutableBytes] length:[tile sizeOfVertices]];
        }
    }
    
    glBufferData(GL_ARRAY_BUFFER, totalDataSize, [vertexData mutableBytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
}

- (void)tearDownGL{
    glDeleteBuffers(1, &_vertexBuffer);
    for (NSArray *row in _tiles) {
        for (SWMTileSpace *tileSpace in row) {
            [[tileSpace tile] tearDownGL];
        }
    }
}

@end
