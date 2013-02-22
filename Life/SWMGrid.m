//
//  SWMGrid.m
//  Life
//
//  Created by Spencer MacKinnon on 2/16/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMGrid.h"

@implementation SWMGrid

@synthesize tiles = _tiles;
@synthesize topLeftBoundary = _topLeftBoundary;
@synthesize bottomRightBoundary = _bottomRightBoundary;

float const TILE_SIDE_LENGTH = 0.0015f;

- (id)initWithTopLeft:(GLKVector3)topLeft withBottomRight:(GLKVector3)bottomRight{
    
    self = [super init];
    if (self) {
        
        _topLeftBoundary = topLeft;
        _bottomRightBoundary = bottomRight;
        
        _width = _bottomRightBoundary.x - _topLeftBoundary.x;
        _height = _topLeftBoundary.y - _bottomRightBoundary.y;
        
        _numberOfTilesWidth = _width / TILE_SIDE_LENGTH ;
        _numberOfTilesHeight = _height / TILE_SIDE_LENGTH;
        
        if (_numberOfTilesWidth == 0 || _numberOfTilesHeight == 0) {
            return NULL;
        }
        
        _tiles = [[NSMutableArray alloc] init];
        
        for (int i=0; i < _numberOfTilesHeight; i++) {
            
            NSMutableArray *row = [[NSMutableArray alloc] init];
            for (int j=0; j < _numberOfTilesWidth; j++) {
                SWMTileSpace *tileSpace = [[SWMTileSpace alloc] init];
                
                int asdf = arc4random() % 5;
                if (asdf == 0) {
                    [tileSpace setIsActive:true];
                }
                
                [tileSpace setRow:i];
                [tileSpace setColumn:j];
                [[tileSpace tile] setModelViewMatrix:[self generateModelViewMatrixForRow:i andColumn:j]];
                
                [row addObject:tileSpace];
            }
            [_tiles addObject:row];
        }
    }
    
    return self;
}

- (GLKMatrix4)generateModelViewMatrixForRow:(int)row andColumn:(int)column{
    
    float x = row * TILE_SIDE_LENGTH;
    x = _topLeftBoundary.x + x;
    
    float y = column * TILE_SIDE_LENGTH;
    y = _topLeftBoundary.y - y;
    
    return GLKMatrix4MakeTranslation(x, y, -0.1f);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    for (NSArray *row in _tiles) {
        for (SWMTileSpace *tileSpace in row) {
            
            if ([tileSpace isActive]) {
                [[tileSpace tile] glkView:view drawInRect:rect];
            }
        }
    }
}

- (bool)testWithinGridSpace:(CGPoint)point{
    
    return true;
}

-(void)setupGL{
    
    for (NSArray *row in _tiles) {
        for (SWMTileSpace *tileSpace in row) {
            [[tileSpace tile] setupGL];
        }
    }
}

- (void)tearDownGL{
    for (NSArray *row in _tiles) {
        for (SWMTileSpace *tileSpace in row) {
            [[tileSpace tile] tearDownGL];
        }
    }
}

@end
