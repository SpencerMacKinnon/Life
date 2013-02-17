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

-(id)init{
    self = [super init];
    if (self) {
        SWMTile *firstTile = [[SWMTile alloc] init];
        SWMTile *secondTile = [[SWMTile alloc] init2];
        
        _tiles = [[NSMutableArray alloc] initWithObjects:firstTile, secondTile, nil];
    }
    
    return self;
}

@end
