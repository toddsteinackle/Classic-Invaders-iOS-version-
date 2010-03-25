//
//  Player.m
//  ClassicInvaders
//
//  Created by Todd Steinackle on 3/16/10.
//  Copyright 2010 The No Quarter Arcade. All rights reserved.
//

#import "Player.h"
#import "GameScene.h"
#import "GameController.h"
#import "SoundManager.h"
#import "SpriteSheet.h"
#import "Animation.h"
#import "PackedSpriteSheet.h"
#import "Alien.h"
//#import "Shot.h"

@implementation Player

@synthesize playerInitialXShotPostion_;
@synthesize playerInitialYShotPostion_;

- (void)movementWithDelta:(float)aDelta {

    // don't move off left hand side of the screen
    if (dx_ < 0 && pixelLocation_.x < scene_.screenSidePadding_) {
        return;
    }
    // don't move off right hand side of the screen
    if (dx_ > 0 && pixelLocation_.x > rightScreenBoundary_ - scene_.screenSidePadding_) {
        return;
    }
    pixelLocation_.x += aDelta * dx_;

}

- (id)initWithPixelLocation:(CGPoint)aLocation {

    self = [super init];
	if (self != nil) {
        width_ = 43;
        height_ = 25;
		PackedSpriteSheet *pss = [PackedSpriteSheet packedSpriteSheetForImageNamed:@"pss.png"
                                                                       controlFile:@"pss_coordinates"
                                                                       imageFilter:GL_LINEAR];
		Image *SpriteSheetImage = [[pss imageForKey:@"ship.png"] retain];
        scaleFactor_ = .85;
        SpriteSheetImage.scale = Scale2fMake(scaleFactor_, scaleFactor_);
        spriteSheet_ = [SpriteSheet spriteSheetForImage:SpriteSheetImage
                                               sheetKey:@"ship.png"
                                             spriteSize:CGSizeMake(width_, height_)
                                                spacing:1
                                                 margin:0];

        animation_ = [[Animation alloc] init];
		float delay = 0.2;
		[animation_ addFrameWithImage:[spriteSheet_ spriteImageAtCoords:CGPointMake(0, 0)] delay:delay];
        animation_.state = kAnimationState_Running;
        animation_.type = kAnimationType_PingPong;

		[SpriteSheetImage release];

        pixelLocation_.x = aLocation.x;
        pixelLocation_.y = aLocation.y;
        playerInitialXShotPostion_ = scaleFactor_ * (width_ - 5)  / 2;
        playerInitialYShotPostion_ = scaleFactor_ * 16;
        rightScreenBoundary_ = scene_.screenBounds_.size.width - (width_ * scaleFactor_);
        collisionWidth_ = scaleFactor_ * width_ * .9f;
        collisionHeight_ = scaleFactor_ * height_ *.9f;
        collisionXOffset_ = ((scaleFactor_ * width_) - collisionWidth_) / 2;
        collisionYOffset_ = ((scaleFactor_ * height_) - collisionHeight_) / 2;
        active_ = TRUE;
    }
    return self;
}


- (void)updateWithDelta:(GLfloat)aDelta scene:(AbstractScene*)aScene {
    [animation_ updateWithDelta:aDelta];
}

- (void)render {
    [super render];
    [animation_ renderAtPoint:CGPointMake(pixelLocation_.x, pixelLocation_.y)];
}

- (void)checkForCollisionWithEntity:(AbstractEntity *)otherEntity {
    if ((pixelLocation_.y + collisionYOffset_ >= otherEntity.pixelLocation_.y + otherEntity.collisionYOffset_ + otherEntity.collisionHeight_) ||
        (pixelLocation_.x + collisionXOffset_ >= otherEntity.pixelLocation_.x + otherEntity.collisionXOffset_ + otherEntity.collisionWidth_) ||
        (otherEntity.pixelLocation_.y + otherEntity.collisionYOffset_ >= pixelLocation_.y + collisionYOffset_ + collisionHeight_) ||
        (otherEntity.pixelLocation_.x + otherEntity.collisionXOffset_ >= pixelLocation_.x + collisionXOffset_ + collisionWidth_)) {
        return;
    }

    if ([otherEntity isKindOfClass:[Alien class]]) {
        active_ = FALSE;
        otherEntity.active_ = FALSE;
        [scene_ playerKilledWithAlienFlag:TRUE];
    } else {
        active_ = FALSE;
        otherEntity.active_ = FALSE;
        [scene_ playerKilledWithAlienFlag:FALSE];
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
