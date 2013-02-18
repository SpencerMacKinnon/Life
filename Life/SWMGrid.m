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
@synthesize topRightBoundary = _topRightBoundary;
@synthesize bottomLeftBoundary = _bottomLeftBoundary;
@synthesize bottomRightBoundary = _bottomRightBoundary;

-(id)init{
    self = [super init];
    if (self) {
        SWMTile *firstTile = [[SWMTile alloc] init];
        SWMTile *secondTile = [[SWMTile alloc] init];
        
        _tiles = [[NSMutableArray alloc] initWithObjects:firstTile, secondTile, nil];
    }
    
    return self;
}

@end
