//
//  ParticleEmitter.h
//

#import "Global.h"

@class GameController;
@class Image;

// Structure that holds the location and size for each point sprite
typedef struct {
	GLfloat x;
	GLfloat y;
	GLfloat size;
	Color4f color;
} PointSprite;

// Structure used to hold particle specific information
typedef struct {
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
	GLfloat radius;
	GLfloat radiusDelta;
	GLfloat angle;
	GLfloat degreesPerSecond;
	GLfloat particleSize;
	GLfloat particleSizeDelta;
	GLfloat timeToLive;
} Particle;

#define MAXIMUM_UPDATE_RATE 45	// The maximum number of updates that occur per frame

// The particleEmitter allows you to define parameters that are used when generating particles.
// These particles are OpenGL particle sprites that based on the parameters provided each have
// their own characteristics such as speed, lifespan, start and end colors etc.  Using these
// particle emitters allows you to create organic looking effects such as smoke, fire and
// explosions.
//
// The design for this particle emitter was influenced by the point sprite particle system
// used in the Cocos2D game engine
//
@interface ParticleEmitter : NSObject {

	/////////////////// Singleton Managers
	GameController *sharedGameController;

	/////////////////// Particle iVars
	Image *texture;
	Vector2f sourcePosition, sourcePositionVariance;
	GLfloat angle, angleVariance;
	GLfloat speed, speedVariance;
	Vector2f gravity;
	GLfloat particleLifespan, particleLifespanVariance;
	Color4f startColor, startColorVariance;
	Color4f finishColor, finishColorVariance;
	GLfloat startParticleSize, startParticleSizeVariance;
	GLfloat finishParticleSize, finishParticleSizeVariance;
	GLuint maxParticles;
	GLint particleCount;
	GLfloat emissionRate;
	GLfloat emitCounter;
	GLfloat elapsedTime;
	GLfloat duration;
	BOOL blendAdditive;						// Should the OpenGL Blendmode be additive

	//////////////////// Particle ivars only used when a maxRadius value is provided.  These values are used for
	//////////////////// the special purpose of creating the spinning portal emitter
	GLfloat maxRadius;						// Max radius at which particles are drawn when rotating
	GLfloat maxRadiusVariance;				// Variance of the maxRadius
	GLfloat radiusSpeed;					// The speed at which a particle moves from maxRadius to minRadius
	GLfloat minRadius;						// Radius from source below which a particle dies
	GLfloat rotatePerSecond;				// Numeber of degress to rotate a particle around the source pos per second
	GLfloat rotatePerSecondVariance;		// Variance in degrees for rotatePerSecond

	//////////////////// Particle Emitter iVars
	BOOL active;
	BOOL useTexture;
	GLint particleIndex;		// Stores the number of particles that are going to be rendered


	///////////////////// Render
	GLuint verticesID;			// Holds the buffer name of the VBO that stores the color and vertices info for the particles
	Particle *particles;		// Array of particles that hold the particle emitters particle details
	PointSprite *vertices;		// Array of vertices and color information for each particle to be rendered

}

@property(nonatomic, assign) Vector2f sourcePosition;
@property(nonatomic, assign) GLint particleCount;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, assign) GLfloat duration;

// Initialises a particle emitter using configuration read from a file
- (id)initParticleEmitterWithFile:(NSString*)aFileName ofType:(NSString*)aFileType;

// Renders the particles for this emitter to the screen
- (void)renderParticles;

// Updates all particles in the particle emitter
- (void)updateWithDelta:(GLfloat)aDelta;

// Stops the particle emitter
- (void)stopParticleEmitter;

@end
