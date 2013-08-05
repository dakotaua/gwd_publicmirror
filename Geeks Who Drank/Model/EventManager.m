//
//  EventManager.m
//  Geeks Who Drank
//
//  Created by Colin Scott-Fleming on 8/5/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "EventManager.h"

@interface EventManager()

@property (readwrite, strong, nonatomic) NSString *path;
@property (readwrite, strong, nonatomic) NSMutableArray *eventList;
@property (strong, nonatomic) NSMutableArray *eventPlist;

@end

@implementation EventManager

+ (EventManager *)sharedManager {
    static EventManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[EventManager alloc] init];
    });
    
    return __instance;
}

// TODO: Add setSharedManager for coverage testing and use OCMock

- (id)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _path = [documentsDirectory stringByAppendingPathComponent:@"events.dat"];
        NSLog(@"Saving events in %@", _path);
    }
    
    return self;
}

#pragma mark - Properties
- (NSMutableArray *)eventList {
    if (!_eventList) [self loadState];
    return _eventList;
}

- (NSMutableArray *)eventPlist {
    if (!_eventPlist)
        _eventPlist = [[NSMutableArray alloc] init];
    
    // TODO: Serialize the event list
    
    return _eventPlist;
}

#pragma mark - Event Management Methods
- (void)addDefaultQuizEvent {
    QuizEvent *newEvent = (QuizEvent *) [[QuizEvent alloc] initWithTempValues];
    [self.eventList addObject:newEvent];
}

- (void)addQuizEvent:(QuizEvent *)event {
    [self.eventList addObject:event];
}

- (void)removeQuizEvent:(QuizEvent *)event {
    if ([self.eventList containsObject:event]) {
        [self.eventList removeObject:event];
    }
}

#pragma mark - Quiz Management Methods
- (BOOL)quizEvent:(QuizEvent *)event containsTeam:(NSString *)teamName {
    for (Quiz *quiz in event.quizzes) {
        if ([quiz.teamName isEqualToString:teamName]) return YES;
    }
    
    return NO;
}

- (Quiz *)quizEvent:(QuizEvent *)event quizForTeamName:(NSString *)teamName {
    if ([self quizEvent:event containsTeam:teamName]) {
        for (Quiz *quiz in event.quizzes) {
            if ([quiz.teamName isEqualToString:teamName]) {
                return quiz;
            }
        }
    }
    
    return nil;
}

- (void)addNewTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event {
    if ([self.eventList containsObject:event]) {
        Quiz *newQuiz = [[Quiz alloc] initWithName:teamName];
        [self.eventList addObject:newQuiz];
    }
}

- (void)removeTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event {
    if ([self.eventList containsObject:event]) {
        if ([self quizEvent:event containsTeam:teamName]) {
            Quiz *quizToRemove = [self quizEvent:event quizForTeamName:teamName];
            [self.eventList removeObject:quizToRemove];
        }
    }
}

#pragma mark - Data Management Methods
- (void)saveState {
    [NSKeyedArchiver archiveRootObject:self.eventPlist toFile:self.path];
}

- (void)loadState {
    NSMutableArray *events = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
    
    if (!events) {
        events = [[NSMutableArray alloc] init];
    }
    
    self.eventList = events;
}

@end
