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

float const TILE_SIDE_LENGTH = 0.001f;

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
        
        colours[RED] = GLKVector4Make(0.824, 0.192, 0.365, 0.0);
        colours[YELLOW] = GLKVector4Make(0.969, 0.784, 0.031, 0.0);
        colours[ORANGE] = GLKVector4Make(0.914, 0.533, 0.075, 0.0);
        colours[BLUE] = GLKVector4Make(0.133, 0.71, 0.749, 0.0);
        colours[PURPLE] = GLKVector4Make(0.529, 0.404, 0.651, 0.0);
        colours[GREEN] = GLKVector4Make(0.533, 0.757, 0.204, 0.0);
        
        _displayColours = false;
        
        [self createGrid];
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

- (void)determineNextIteration{
    
    //int totalTiles = _numberOfTilesWidth * _numberOfTilesHeight;
    NSMutableArray *activeNextTurn = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_tiles count]; i++) {
        
        NSArray *row = [_tiles objectAtIndex:i];
        
        for (int j = 0; j < [row count]; j++) {
            SWMTile *tile = [row objectAtIndex:j];
            BOOL isActiveNextTurn = [self determineNextIterationForTileWithRow:j andColumn:i cellIsAlive:[tile isActive]];
            [activeNextTurn addObject:[NSNumber numberWithBool:isActiveNextTurn]];
        }
    }
    
    int activeIndex = 0;
    
    for (int i = 0; i < [_tiles count]; i++) {
        
        NSArray *row = [_tiles objectAtIndex:i];
        
        for (int j = 0; j < [row count]; j++) {

            BOOL isActiveNextTurn = [[activeNextTurn objectAtIndex:activeIndex] boolValue];
            SWMTile *tile = [row objectAtIndex:j];
            if ((![tile isActive]) && (isActiveNextTurn)) {
                [tile setDiffuseLightColour:[self getRandomColour]];
            }
            [tile setIsActive:isActiveNextTurn];
            activeIndex++;
        }
    }
}
- (BOOL)determineNextIterationForTileWithRow:(int)row andColumn:(int)column cellIsAlive:(bool)cellIsAlive{
    
    int count = 0;
    
    for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
            if (!(i == 0 && j == 0)) {
                int x = (row + j) % _numberOfTilesWidth;
                if (x < 0) {
                    x = _numberOfTilesWidth - 1;
                }
                int y = (column + i) % _numberOfTilesHeight;
                if (y < 0) {
                    y = _numberOfTilesHeight - 1;
                }
                
                if ([[[_tiles objectAtIndex:y] objectAtIndex:x] isActive]) {
                    count++;
                }
            }
        }
    }
    
    return (((count == 2) && cellIsAlive) || (count == 3));
}

- (GLKVector4)getRandomColour{
    return colours[arc4random() % NUM_COLOURS];
}

- (void)toggleColour{
    _displayColours = !_displayColours;
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
    
    for (NSMutableArray *row in _tiles) {
        for (SWMTile *tile in row) {
            int numberOfVertices = [tile numberOfVertices];
            if ([tile isActive]) {
                [tile glkView:view drawInRect:rect withColour:_displayColours];
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
        for (SWMTile *tile in row) {
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
    for (NSMutableArray *row in _tiles) {
        for (SWMTile *tile in row) {
            [tile tearDownGL];
        }
    }
    
    [self emptyGrid];
}

- (void)renewGrid{
    [self emptyGrid];
    [self createGrid];
}

- (void)emptyGrid{
    for (NSMutableArray *row in _tiles) {
        [row removeAllObjects];
    }
    
    [_tiles removeAllObjects];
}

- (void)createGrid{
    
    for (int i=0; i < _numberOfTilesHeight; i++) {
        
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j < _numberOfTilesWidth; j++) {
            SWMTile *tile = [[SWMTile alloc] initWithShader:_shader];
            
            if (arc4random() % 4 == 0) {
                [tile setIsActive:true];
            }
            
            [tile setRow:i];
            [tile setColumn:j];
            [tile setModelViewMatrix:[self generateModelViewMatrixForRow:j andColumn:i]];
            [tile setDiffuseLightColour:[self getRandomColour]];
            [tile setVertexArray:_va];
            [tile loadShaders];
            
            [row addObject:tile];
        }
        [_tiles addObject:row];
    }
}

@end
