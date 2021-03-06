//
//  MainMenuViewController.h
//  ClassicInvaders
//
//  Created by Todd Steinackle on 1/1/11.
//  Copyright 2011 The No Quarter Arcade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundManager;
@class GameController;
@class AbstractScene;
@class ClassicInvadersAppDelegate;

@interface MainMenuViewController : UIViewController {
    SoundManager *sharedSoundManager;
	GameController *sharedGameController;
    AbstractScene *menuScene;
    ClassicInvadersAppDelegate *appDelegate;
    IBOutlet UIButton *scoreButton;
}

@property (nonatomic, assign) AbstractScene *menuScene;

- (void)hide:(id)sender;
- (IBAction)newGame:(id)aSender;
- (IBAction)highScores:(id)aSender;
- (IBAction)showHelp:(id)aSender;
- (IBAction)showAbout:(id)aSender;
- (IBAction)showSettings:(id)aSender;
- (void)setScoreButton;

@end
