//
//  UploadQuizViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/18/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventTableEventCell.h"
#import "EventTableNewEventCell.h"
#import "QuizEvent.h"

@interface EventListViewController : UIViewController

@property (strong,nonatomic) NSMutableArray* quizEvents;

- (IBAction)editQuiz:(EventTableEventCell *)sender;
- (IBAction)startNewQuiz:(UILongPressGestureRecognizer *)gesture;

@end
