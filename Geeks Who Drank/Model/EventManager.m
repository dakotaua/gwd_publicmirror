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
    
}

- (void)addQuizEvent:(QuizEvent *)event {
    
}

- (void)removeQuizEvent:(QuizEvent *)event {
    OCMockObject *obj = [OCMockObject mockForClass:[QuizEvent class]];
}

#pragma mark - Quiz Management Methods
- (BOOL)quizEvent:(QuizEvent *)event hasTeam:(NSString *)teamName {
    return NO;
}

- (void)addNewTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event {
    
}

- (void)removeTeam:(NSString *)teamName forQuizEvent:(QuizEvent *)event {
    
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
