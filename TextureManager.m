//
//  TextureManager.m
//

#import "TextureManager.h"
#import "SynthesizeSingleton.h"
#import "Texture2D.h"
#import "PackedSpriteSheet.h"
#import "SpriteSheet.h"

@implementation TextureManager

SYNTHESIZE_SINGLETON_FOR_CLASS(TextureManager);

- (void)dealloc {

    // Release the cachedTextures dictionary.
	[cachedTextures release];
	[super dealloc];
}


- (id)init {
	// Initialize a dictionary with an initial size to allocate some memory, but it will
    // increase in size as necessary as it is mutable.
	cachedTextures = [[NSMutableDictionary alloc] init];
	return self;
}

- (Texture2D*)textureWithFileName:(NSString*)aName ofType:(NSString*)aType filter:(GLenum)aFilter {

    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *cachedTexture;

	// The statement below actually sets the value of cachedTexture as well as check it
	NSString *key = [NSString stringWithFormat:@"%@.%@", aName, aType];

	if(cachedTexture = [cachedTextures objectForKey:key]) {
		return cachedTexture;
	}

	// We are using imageWithContentsOfFile rather than imageNamed, as imageNamed caches the image in the device.
	// This can lead to memory issue as we do not have direct control over when it would be released.  Not using
	// imageNamed means that it is not cached by the OS and we have control over when it is released.
	NSString *path = [[NSBundle mainBundle] pathForResource:aName ofType:aType];
	cachedTexture = [[Texture2D alloc] initWithImage:[UIImage imageWithContentsOfFile:path] filter:aFilter];
	[cachedTextures setObject:cachedTexture forKey:[NSString stringWithFormat:@"%@.%@", aName, aType]];

	// Return the texture which is autoreleased as the caller is responsible for it
    return [cachedTexture autorelease];
}

- (BOOL)releaseTextureWithName:(NSString*)aName ofType:(NSString*)aType {

	// Construct the key from the filename and type
	NSString *key = [NSString stringWithFormat:@"%@.%@", aName, aType];

    // If a texture was found we can remove it from the cachedTextures and return YES.
    if([cachedTextures objectForKey:key]) {
        [cachedTextures removeObjectForKey:key];
        return YES;
    }

    // No texture was found with the supplied key so log that and return NO;
#ifdef MYDEBUG
    NSLog(@"INFO - Resource Manager: A texture with the key '%@.%@' could not be found to release.", aName, aType);
#endif
    return NO;
}

- (void)releaseAllTextures {
#ifdef MYDEBUG
    SLQLOG(@"INFO - Resource Manager: Releasing all cached textures.");
#endif
    [cachedTextures removeAllObjects];
}

@end
