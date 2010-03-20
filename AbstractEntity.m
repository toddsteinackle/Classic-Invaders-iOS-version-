//
//  AbstractEntity.m
//  SLQTSOR
//
//  Created by Michael Daley on 04/03/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "AbstractEntity.h"
#import "AbstractScene.h"
#import "Primatives.h"
#import "BitmapFont.h"
#import "AbstractEntity.h"
#import "AbstractObject.h"

@implementation AbstractEntity

@synthesize tileLocation_;
@synthesize state_;
@synthesize image_;
//@synthesize energyDrain;
@synthesize pixelLocation_;
@synthesize active_;
@synthesize dx_;
@synthesize collisionWidth_;
@synthesize collisionHeight_;
@synthesize collisionXOffset_;
@synthesize collisionYOffset_;

- (void)dealloc {
//	SLQLOG(@"INFO - %@: Deallocating", [self description]);
	[super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)init {
	self = [super init];
	if (self != nil) {
		// Grab references to the singleton managers
		sharedGameController_ = [GameController sharedGameController];
		sharedSoundManager_ = [SoundManager sharedSoundManager];

		// Grab a reference to the current game screne
		scene_ = (GameScene*)sharedGameController_.currentScene;

	}
	return self;
}

- (id)initWithTileLocation:(CGPoint)aLocation {
	self = [self init];
	return self;
}

- (id)initWithPixelLocation:(CGPoint)aLocation {
    self = [self init];
    return self;
}

#pragma mark -
#pragma mark Updating

- (void)updateWithDelta:(float)aDelta scene:(AbstractScene*)aScene {
	// OVERRIDE
}

#pragma mark -
#pragma mark Rendering

- (void)render {

// Debug code that allows us to draw bounding boxes for the entity
#ifdef SCB
		// Draw the collision bounds in green
		glColor4f(0, 1, 0, 1);
		drawBox([self collisionBounds]);

		// Draw the movement bounds in blue
		glColor4f(0, 0, 1, 1);
		drawBox([self movementBounds]);
#endif

}

#pragma mark -
#pragma mark Bounds & collision

- (BOOL)isEntityInTileAtCoords:(CGPoint)aCoords {
	CGRect bRect = [self movementBounds];
	BoundingBoxTileQuad bbtq = getTileCoordsForBoundingRect(bRect, CGSizeMake(kTile_Width, kTile_Height));
    if((int)bbtq.x1 == (int)aCoords.x && (int)bbtq.y1 == (int)aCoords.y ||
       (int)bbtq.x2 == (int)aCoords.x && (int)bbtq.y2 == (int)aCoords.y ||
       (int)bbtq.x3 == (int)aCoords.x && (int)bbtq.y3 == (int)aCoords.y ||
       (int)bbtq.x4 == (int)aCoords.x && (int)bbtq.y4 == (int)aCoords.y) {
        return YES;
    }
    return NO;
}

- (CGRect)movementBounds { return CGRectZero; }

- (CGRect)collisionBounds { return CGRectZero; }

- (void)checkForCollisionWithEntity:(AbstractEntity*)aEntity {}

- (void)checkForCollisionWithObject:(AbstractObject*)aObject {}

BoundingBoxTileQuad getTileCoordsForBoundingRect(CGRect aRect, CGSize aTileSize) {

	BoundingBoxTileQuad bbtq;

	// Bottom left
	bbtq.x1 = (int)(aRect.origin.x / aTileSize.width);
	bbtq.y1 = (int)(aRect.origin.y / aTileSize.height);

	// Bottom right
	bbtq.x2 = (int)((aRect.origin.x + aRect.size.width) / aTileSize.width);
	bbtq.y2 = bbtq.y1;

	// Top right
	bbtq.x3 = bbtq.x2;
    bbtq.y3 = (int)((aRect.origin.y + aRect.size.height) / aTileSize.height);

	// Top left
	bbtq.x4 = bbtq.x1;
	bbtq.y4 = bbtq.y3;

	return bbtq;
}

#pragma mark -
#pragma mark Encoding

- (id)initWithCoder:(NSCoder *)aDecoder {
	[self initWithTileLocation:[aDecoder decodeCGPointForKey:@"position"]];
    //	speed = [aDecoder decodeFloatForKey:@"speed"];
    //	angle = [aDecoder decodeFloatForKey:@"angle"];
	state_ = [aDecoder decodeIntForKey:@"entityState"];
	if (state_ == kEntityState_Dying)
		state_ = kEntityState_Dead;
	//offScreenTimer = [aDecoder decodeFloatForKey:@"offScreenTimer"];
	//appearingTimer = [aDecoder decodeFloatForKey:@"appearingTimer"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeCGPoint:tileLocation_ forKey:@"position"];
	//[aCoder encodeFloat:speed forKey:@"speed"];
	//[aCoder encodeFloat:angle forKey:@"angle"];
	[aCoder encodeInt:state_ forKey:@"entityState"];
	//[aCoder encodeFloat:offScreenTimer forKey:@"offScreenTimer"];
	//[aCoder encodeFloat:appearingTimer forKey:@"appearingTimer"];
}

@end
