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

@end

@implementation EventManager

static dispatch_once_t onceToken;
static EventManager *__instance = nil;

#pragma mark - Properties
- (NSMutableArray *)eventList {
    if (!_eventList) [self loadState];
    return _eventList;
}

#pragma mark - Initializers and Singleton
+ (EventManager *)sharedManager {
    dispatch_once(&onceToken, ^{
        __instance = [[EventManager alloc] init];
    });
    
    return __instance;
}

+ (void)setSharedManager:(EventManager *)instance {
    onceToken = 0;
    __instance.path = nil;
    __instance.eventList = nil;
    __instance = instance;
}

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

#pragma mark - Event Management Methods
- (QuizEvent *)eventForLocation:(NSString *)location onDate:(NSDate *)date {
    for (QuizEvent *event in self.eventList) {
        if ([event.location isEqualToString:location] &&
            [event.quizDate isEqualToDate:date]) {
            return event;
        }
    }
    
    return nil;
}

- (NSUInteger)eventCount {
    return [self.eventList count];
}

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
    // Return nil if this event is unmanaged.
    if (![self.eventList containsObject:event]) {
        return nil;
    }
    
    if ([self quizEvent:event containsTeam:teamName]) {
        for (Quiz *quiz in event.quizzes) {
            if ([quiz.teamName isEqualToString:teamName]) {
                return quiz;
            }
        }
    }
    
    return nil;
}

- (NSUInteger)quizCountForEvent:(QuizEvent *)event {
    return [event.quizzes count];
}

- (void)addNewTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event {
    if ([self.eventList containsObject:event]) {
        Quiz *newQuiz = [[Quiz alloc] initWithName:teamName];
        [event.quizzes addObject:newQuiz];
    }
}

- (void)removeTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event {
    if ([self.eventList containsObject:event]) {
        if ([self quizEvent:event containsTeam:teamName]) {
            Quiz *quizToRemove = [self quizEvent:event quizForTeamName:teamName];
            [event.quizzes removeObject:quizToRemove];
        }
    }
}

#pragma mark - Data Management Methods
- (void)saveState {
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    for (QuizEvent *event in self.eventList) {
        [events addObject:[event serialize]];
    }
    
    [NSKeyedArchiver archiveRootObject:events toFile:self.path];
}

- (void)loadState {
    NSArray *events = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
    
    if (!events) {
        self.eventList = [[NSMutableArray alloc] init];
    }
    
    else {
        self.eventList = [[NSMutableArray alloc] init];
        for (NSDictionary *serializedEvent in events) {
            QuizEvent *event = [[QuizEvent alloc] initFromDictionary:serializedEvent];
            [self.eventList addObject:event];
        }
    }
}

@end
