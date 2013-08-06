//
//  EventManagerTests.m
//  Geeks Who Drank
//
//  Created by Colin Scott-Fleming on 8/5/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "EventManagerTests.h"
#import "EventManager.h"

@implementation EventManagerTests

- (void)setUp {
    [super setUp];
    
    NSError *error = nil;
    EventManager *eventManager = [EventManager sharedManager];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:eventManager.path]) {
        [fileManager removeItemAtPath:eventManager.path error:&error];
    }
    
    STAssertNil(error, @"Got an error when removing %@: %@", eventManager.path, error);
}

- (void)tearDown {
    NSError *error = nil;
    EventManager *eventManager = [EventManager sharedManager];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:eventManager.path]) {
        [fileManager removeItemAtPath:eventManager.path error:&error];
    }
    
    STAssertNil(error, @"Got an error when removing %@: %@", eventManager.path, error);
    
    [super tearDown];
}

- (void)testEventManagerSingleton {
    EventManager *eventManager = [EventManager sharedManager];
    STAssertTrue([eventManager isKindOfClass:[EventManager class]], @"Failed: eventManager is not an EventManager?");
    
    EventManager *em2 = [EventManager sharedManager];
    STAssertTrue(em2 == eventManager, @"Failed: Something is messed up with the singleton initializer.");
    
    [EventManager setSharedManager:nil];
    eventManager = [EventManager sharedManager];
    STAssertNotNil(eventManager, @"Failed: Something is messed up with the singleton reset class method.");
}

- (void)testEventManagerAddEventBasic {
    EventManager *eventManager = [EventManager sharedManager];
    
    [eventManager addDefaultQuizEvent];
    
    int count = [eventManager.eventList count];
    
    STAssertEquals(count, 1, @"An event was not added to the EventManager properly.");
    
    [EventManager setSharedManager:nil];
}

- (void)testEventManagerSingletonAdd {
    EventManager *eventManager = [EventManager sharedManager];
    
    [eventManager addDefaultQuizEvent];
    int count = [eventManager.eventList count];
    
    STAssertEquals(1, count, @"List was not emptied properly before adding a new event.");
    
    EventManager *em = [EventManager sharedManager];
    
    count = [em.eventList count];
    STAssertEquals(1, count, @"Count did not carry over in the singleton share.");
    
    [em addDefaultQuizEvent];
    count = [em.eventList count];
    STAssertEquals(2, count, @"Count did not increment properly when a second event was added.");
    
    [eventManager addDefaultQuizEvent];
    STAssertEquals([em.eventList count], [eventManager.eventList count], @"Counts were not the same.");
    
    [EventManager setSharedManager:nil];
}

- (void)testEventManagerAddRemoveSpecificEvents {
    EventManager *eventManager = [EventManager sharedManager];
    QuizEvent *e1 = [[QuizEvent alloc] initWithTempValues];
    QuizEvent *e2 = [[QuizEvent alloc] initWithTempValues];
    QuizEvent *e3 = [[QuizEvent alloc] initWithTempValues];
    
    e2.location = @"Not the default location string.";
    e3.location = @"Also a different string.";
    
    STAssertFalse([e1.location isEqualToString:e2.location], @"Location strings were not different");
    STAssertFalse([e1.location isEqualToString:e3.location], @"Location strings were not different");
    STAssertFalse([e2.location isEqualToString:e3.location], @"Location strings were not different");
    
    // Test removing from an empty list
    [eventManager removeQuizEvent:e1];
    // Should not crash...?
    
    [eventManager addQuizEvent:e1];
    [eventManager addQuizEvent:e2];
    [eventManager addQuizEvent:e3];
    
    int count = [eventManager.eventList count];
    STAssertEquals(3, count, @"An event was not added properly.");
    
    [eventManager removeQuizEvent:e1];
    count = [eventManager.eventList count];
    STAssertEquals(2, count, @"Event 1 was not removed properly.");
    
    [eventManager removeQuizEvent:e1];
    count = [eventManager.eventList count];
    STAssertEquals(2, count, @"Event 2 was removed twice.");
    
    [eventManager removeQuizEvent:e2];
    count = [eventManager.eventList count];
    STAssertEquals(1, count, @"Event 2 was not removed properly.");
    
    [eventManager addQuizEvent:e1];
    count = [eventManager.eventList count];
    STAssertEquals(2, count, @"Event 1 was not re-added properly.");
    
    [EventManager setSharedManager:nil];
}

- (void)testEventManagerEventSearch {
    EventManager *eventManager = [EventManager sharedManager];
    
    NSString *quizMaster = @"Ralph";
    NSString *location = @"The Pub";
    NSDate *quizDate = [NSDate date];
    NSArray *quizzes = @[];
    
    QuizEvent *event = [[QuizEvent alloc] initFromDictionary:@{
                        @"quizMaster":quizMaster,
                        @"location":location,
                        @"quizDate":quizDate,
                        @"quizzes":quizzes}];
    
    [eventManager addQuizEvent:event];
    int count = [eventManager.eventList count];
    STAssertEquals(1, count, @"Event was not added properly.");
    
    QuizEvent *search = [eventManager eventForLocation:@"Fake location" onDate:[NSDate date]];
    
    STAssertNil(search, @"Found an object that does not exist.");
    
    search = [eventManager eventForLocation:@"The Pub" onDate:quizDate];
    STAssertNotNil(search, @"Did not find an object that should exist.");
    
    [EventManager setSharedManager:nil];
}

- (void)testEventManagerTeamsAndTeamSearch {
    EventManager *eventManager = [EventManager sharedManager];
    
    [eventManager addQuizEvent:[[QuizEvent alloc] initWithTempValues]];
    [eventManager addQuizEvent:[[QuizEvent alloc] initWithTempValues]];
    QuizEvent *e1 = [eventManager.eventList objectAtIndex:0];
    QuizEvent *e2 = [eventManager.eventList objectAtIndex:1];
    
    [eventManager addNewTeam:@"Team One" forQuizEvent:e1];
    [eventManager addNewTeam:@"Team Two" forQuizEvent:e1];
    [eventManager addNewTeam:@"Team Three" forQuizEvent:e2];
    [eventManager addNewTeam:@"Team Four" forQuizEvent:e2];
    
    STAssertFalse([eventManager quizEvent:e1 containsTeam:@"Team Three"], @"Found a team in the wrong event");
    STAssertTrue([eventManager quizEvent:e2 containsTeam:@"Team Three"], @"Could find a team in the correct event");
    
    [eventManager removeTeam:@"Team Two" forQuizEvent:e1];
    
    STAssertFalse([eventManager quizEvent:e1 containsTeam:@"Team Two"], @"Found a team that should have been deleted.");
    
    Quiz *search = [eventManager quizEvent:e1 quizForTeamName:@"Team Two"];
    
    STAssertNil(search, @"Found a quiz for a nonexistent team.");
    
    search = [eventManager quizEvent:e2 quizForTeamName:@"Team Four"];
    STAssertNotNil(search, @"Did not find a quiz that should have been found.");
    STAssertTrue([search.teamName isEqualToString:@"Team Four"], @"Team name for found team is incorrect.");
    
    [EventManager setSharedManager:nil];
}

- (void)testEventManagerState {
    EventManager *em = [EventManager sharedManager];
    [em addQuizEvent:[[QuizEvent alloc] initWithTempValues]];
    [em addNewTeam:@"Team One" forQuizEvent:[em.eventList objectAtIndex:0]];
    [em addNewTeam:@"Team Two" forQuizEvent:[em.eventList objectAtIndex:0]];
    
    [em saveState];
    [EventManager setSharedManager:nil];
    em = [EventManager sharedManager];
    [em loadState];
    
    QuizEvent *event = [em.eventList objectAtIndex:0];
    STAssertNotNil(event, @"Load state did not return any quizzes");
    Quiz *search = [em quizEvent:event quizForTeamName:@"Team One"];
    STAssertNotNil(search, @"Could not find first quiz from loaded state.");
    search = [em quizEvent:event quizForTeamName:@"Team Two"];
    STAssertNotNil(search, @"Could not find second quiz from loaded state.");
    
    
}

@end
