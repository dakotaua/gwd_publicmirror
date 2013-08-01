//
//  InitialViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/4/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizEvent.h"
#import "QuizListViewController.h"
#import "EventListViewController.h"

@interface HomeScreenViewController : UIViewController

@property (strong,nonatomic) NSMutableArray* quizEventCollection;
@property (strong, nonatomic) IBOutlet UIButton *quizButton;

// temp solution
@property (strong,nonatomic) NSString* user;

- (IBAction)backToInitialView:(UIStoryboardSegue*)segue;
- (IBAction)startQuizzinPressed:(UIButton *)sender;

@end
