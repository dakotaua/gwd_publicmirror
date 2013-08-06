//
//  EventManager.h
//  Geeks Who Drank
//
//  Created by Colin Scott-Fleming on 8/5/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizEvent.h"

@interface EventManager : NSObject

@property (readonly, strong, nonatomic) NSString *path;
@property (readonly, strong, nonatomic) NSMutableArray *eventList; // Of type Event

// Initialization
+ (EventManager *)sharedManager;
+ (void)setSharedManager:(EventManager *)instance; // For testing only

// Event Management
- (QuizEvent *)eventForLocation:(NSString *)location onDate:(NSDate *)date;
- (NSUInteger)eventCount;

- (void)addDefaultQuizEvent;
- (void)addQuizEvent:(QuizEvent *)event;
- (void)removeQuizEvent:(QuizEvent *)event;

// Quiz Management
- (BOOL)quizEvent:(QuizEvent *)event containsTeam:(NSString *)teamName;
- (Quiz *)quizEvent:(QuizEvent *)event quizForTeamName:(NSString *)teamName;
- (NSUInteger)quizCountForEvent:(QuizEvent *)event;

- (void)addNewTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event;
- (void)removeTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event;

// Data Management
- (void)saveState;
- (void)loadState;

@end
