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
    
    if ([eventManager eventCount]) {
        [eventManager.eventList removeAllObjects];
    }
    
    STAssertNil(error, @"Got an error when removing %@: %@", eventManager.path, error);
    
    [super tearDown];
}

- (void)testEventManagerSingleton {
    
    EventManager *em = [EventManager sharedManager];
    
    STAssertEquals((NSUInteger) 0, [em eventCount], @"Shared manager was not initialized properly.");
}

- (void)testEventManagerAddEventBasic {
    
    EventManager *em = [EventManager sharedManager];
    [em addDefaultQuizEvent];
    STAssertEquals((NSUInteger) 1, [em eventCount], @"Failed to add.");
    
    [em addDefaultQuizEvent];
    STAssertEquals((NSUInteger) 2, [em eventCount], @"Failed to add a second event.");
    
    STAssertEquals((NSUInteger) 2, [em eventCount], @"Failed to maintain count.");
}

- (void)testEventManagerSingletonAddEvents {
    EventManager *em = [EventManager sharedManager];
    
    [em addDefaultQuizEvent];
    
    EventManager *other = [EventManager sharedManager];
    
    STAssertEquals((NSUInteger) 1, [other eventCount], @"Count did not carry over.");
    STAssertEquals([em eventCount], [other eventCount], @"Counts did not match.");
    
    [other addDefaultQuizEvent];
    
    STAssertEquals((NSUInteger) 2, [em eventCount], @"Add did not affect first instance.");
    STAssertEquals([em eventCount], [other eventCount], @"Counts did not match.");

}

- (void)testEventManagerSingletonAddRemoveQuizzes {
    EventManager *em = [EventManager sharedManager];
    
    [em addDefaultQuizEvent];
    [em addDefaultQuizEvent];
    
    QuizEvent *event = [em.eventList objectAtIndex:0];
    QuizEvent *other = [em.eventList objectAtIndex:1];
    
    [em addNewTeam:@"Team One" forQuizEvent:event];
    [em addNewTeam:@"Team Two" forQuizEvent:event];
    
    [em addNewTeam:@"Team Three" forQuizEvent:other];
    [em addNewTeam:@"Team Four" forQuizEvent:other];
    
    EventManager *two = [EventManager sharedManager];
    STAssertEquals((NSUInteger) 2, [two quizCountForEvent:other], @"A quiz was not added to the correct event.");
    STAssertEquals((NSUInteger) 2, [two quizCountForEvent:event], @"A quiz was not added to the correct event.");
    STAssertFalse([em.eventList objectAtIndex:0] == [two.eventList objectAtIndex:1], @"Got the same objects.");
    STAssertTrue([em.eventList objectAtIndex:0] == [two.eventList objectAtIndex:0], @"Got different objects.");
}

- (void)testEventManagerAddFromDictAndAddRemoveSpecificEvents {
    
    EventManager *em = [EventManager sharedManager];
    
    QuizEvent *event = [[QuizEvent alloc] initWithTempValues];
    event.location = @"Nonstandard location.";
    
    STAssertNoThrow([em removeQuizEvent:event], @"Error was thrown when attempting to remove from empty manager.");
    
    [em addQuizEvent:event];
    [em addDefaultQuizEvent];
    
    STAssertEquals((NSUInteger) 2, [em eventCount], @"Verifying count before adding from dict.");
    
    [em addQuizEvent:[[QuizEvent alloc] initFromDictionary:@{@"quizMaster":@"Jeff",
                      @"location":@"Another fake location",
                      @"quizDate":[NSDate date],
                      @"quizzes":@[]}]];
    
    event = [em.eventList objectAtIndex:0];
    QuizEvent *other = [em.eventList objectAtIndex:1];
    
    STAssertEquals((NSUInteger) 3, [em eventCount], @"Failed adding from dict.");
    [em removeQuizEvent:event];
    STAssertEquals((NSUInteger) 2, [em eventCount], @"Event was not removed properly from the list.");
    
    STAssertNoThrow([em removeQuizEvent:event], @"Error was thrown when removing an item that is not in the list.");
    STAssertEquals((NSUInteger) 2, [em eventCount], @"Count is wrong after removing a nonexistent item.");
    
    [em removeQuizEvent:other];
    STAssertEquals((NSUInteger) 1, [em eventCount], @"Count is wrong after removing a second real item.");
    
    [em addQuizEvent:event];
    STAssertEquals((NSUInteger) 2, [em eventCount], @"Adding a previously removed item failed.");
    
}

- (void)testEventManagerEventSearch {
    
    NSString *quizMaster = @"Ralph";
    NSString *location = @"The Pub";
    NSDate *quizDate = [NSDate date];
    NSArray *quizzes = @[];
    
    QuizEvent *event = [[QuizEvent alloc] initFromDictionary:@{
                        @"quizMaster":quizMaster,
                        @"location":location,
                        @"quizDate":quizDate,
                        @"quizzes":quizzes}];
    
    EventManager *em = [EventManager sharedManager];
    [em addQuizEvent:event];
    
    STAssertEquals((NSUInteger) 1, [em eventCount], @"Item was not added from dict.");
    
    QuizEvent *retrieved = [em.eventList objectAtIndex:0];
    STAssertEqualObjects(event, retrieved, @"Object is not the correct object.");
    STAssertTrue([retrieved.quizMaster isEqualToString:quizMaster], @"quizMaster values do not match.");
    STAssertTrue([retrieved.location isEqualToString:location], @"location values do not match.");
    STAssertTrue([retrieved.quizDate isEqualToDate:quizDate], @"quizDate values do not match.");
    STAssertTrue([retrieved.quizzes isEqualToArray:quizzes], @"quizzes arrays do not match.");
    
    QuizEvent *search = [em eventForLocation:location onDate:quizDate];
    STAssertNotNil(search, @"Search should have found a quiz.");
    STAssertTrue([search.quizMaster isEqualToString:quizMaster], @"quizMaster values do not match.");
    STAssertTrue([search.location isEqualToString:location], @"location values do not match.");
    STAssertTrue([search.quizDate isEqualToDate:quizDate], @"quizDate values do not match.");
    STAssertTrue([search.quizzes isEqualToArray:quizzes], @"quizzes arrays do not match.");
    
    search = [em eventForLocation:@"Fake Location" onDate:[NSDate date]];
    STAssertNil(search, @"Search should not have found a quiz.");
}

- (void)testEventManagerTeamsAndTeamSearch {
    EventManager *em = [EventManager sharedManager];
    [em addDefaultQuizEvent];
    [em addDefaultQuizEvent];
    QuizEvent *event = [em.eventList objectAtIndex:1];
    event.location = @"A Different Location";
    
    QuizEvent *other = [em.eventList objectAtIndex:0];
    [em addNewTeam:@"Team One" forQuizEvent:event];
    [em addNewTeam:@"Team Three" forQuizEvent:event];
    [em addNewTeam:@"Team Two" forQuizEvent:other];
    [em addNewTeam:@"Team Four" forQuizEvent:other];
    
    EventManager *anotherView = [EventManager sharedManager];
    STAssertFalse([anotherView quizEvent:[anotherView.eventList objectAtIndex:0] containsTeam:@"Team One"], @"Found a team in the wrong event.");
    STAssertTrue([anotherView quizEvent:[anotherView.eventList objectAtIndex:0] containsTeam:@"Team Two"], @"Did not find a team in the correct event.");
    STAssertFalse([anotherView quizEvent:[anotherView.eventList objectAtIndex:0] containsTeam:@"Team Three"], @"Found a team in the wrong event.");
    STAssertTrue([anotherView quizEvent:[anotherView.eventList objectAtIndex:0] containsTeam:@"Team Four"], @"Did not find a team in the correct event.");
    
    STAssertNotNil([anotherView quizEvent:event quizForTeamName:@"Team One"], @"Could not find a quiz for a team in the correct event.");
    STAssertNil([anotherView quizEvent:event quizForTeamName:@"Team Two"], @"Found a quiz for a team in a different event.");
    STAssertNotNil([anotherView quizEvent:event quizForTeamName:@"Team Three"], @"Could not find a quiz for a team in the correct event.");
    STAssertNil([anotherView quizEvent:event quizForTeamName:@"Team Four"], @"Found a quiz for a team in a different event.");
    
    STAssertNil([anotherView quizEvent:other quizForTeamName:@"Team One"], @"Found a quiz for a team in a different event.");
    STAssertNotNil([anotherView quizEvent:other quizForTeamName:@"Team Two"], @"Could not find a quiz for a team in the correct event.");
    STAssertNil([anotherView quizEvent:other quizForTeamName:@"Team Three"], @"Found a quiz for a team in a different event.");
    STAssertNotNil([anotherView quizEvent:other quizForTeamName:@"Team Four"], @"Could not find a quiz for a team in the correct event.");
    
    STAssertNoThrow([em removeTeam:@"Team One" forQuizEvent:other], @"Threw an error when removing a team from the wrong event.");
    [em removeTeam:@"Team One" forQuizEvent:event];
    STAssertNil([em quizEvent:event quizForTeamName:@"Team One"], @"Team One was not removed from the event.");
    
    [anotherView removeQuizEvent:event];
    
    STAssertFalse([em.eventList containsObject:event], @"Event was not removed properly via singleton.");
    STAssertNil([em quizEvent:event quizForTeamName:@"Team One"], @"Searched an instantiated event that is not in the event manager.");
    STAssertNil([em quizEvent:event quizForTeamName:@"Team Two"], @"Searched an instantiated event for a missing value that is not in the event manager.");
    STAssertNil([em quizEvent:event quizForTeamName:@"Team Three"], @"Searched an instantiated event that is not in the event manager.");
    STAssertNil([em quizEvent:event quizForTeamName:@"Team Four"], @"Searched an instantiated event for a missing value that is not in the event manager.");
    
    STAssertNil([em quizEvent:other quizForTeamName:@"Team One"], @"Found a team that belongs to a removed event.");
    STAssertNotNil([em quizEvent:other quizForTeamName:@"Team Two"], @"Should have found this team.");
    STAssertNil([em quizEvent:other quizForTeamName:@"Team Three"], @"Found a team that belongs to a removed event.");
    STAssertNotNil([em quizEvent:other quizForTeamName:@"Team Four"], @"Should have found this team.");
    
}

- (void)testEventManagerStateAndReset {
    
    EventManager *em = [EventManager sharedManager];
    [em addDefaultQuizEvent];
    QuizEvent *event = [em.eventList objectAtIndex:0];
    
    [em addNewTeam:@"Team One" forQuizEvent:event];
    [em addNewTeam:@"Team Two" forQuizEvent:event];
    
    [em saveState];
    [em.eventList removeAllObjects];
    STAssertEquals((NSUInteger) 0, [em eventCount], @"Events not removed from manager.");
    [em loadState];
    STAssertEquals((NSUInteger) 1, [em eventCount], @"Events not loaded properly from state.");
    
    // Verify state
    event = [em.eventList objectAtIndex:0];
    STAssertTrue([em quizEvent:event containsTeam:@"Team One"], @"Team One missing from state load.");
    STAssertTrue([em quizEvent:event containsTeam:@"Team Two"], @"Team Two missing from state load.");
    STAssertFalse([em quizEvent:event containsTeam:@"Team Six"], @"Found a team that should not have been loaded.");
    
    [em.eventList removeAllObjects];
    
    // Reset the shared manager instance
    [EventManager setSharedManager:nil];
    
    // Should reload the state from disk
    em = [EventManager sharedManager];
    STAssertEquals((NSUInteger) 1, [em eventCount], @"Events not loaded properly from state.");
    
    // Verify state
    event = [em.eventList objectAtIndex:0];
    STAssertTrue([em quizEvent:event containsTeam:@"Team One"], @"Team One missing from state load.");
    STAssertTrue([em quizEvent:event containsTeam:@"Team Two"], @"Team Two missing from state load.");
    STAssertFalse([em quizEvent:event containsTeam:@"Team Six"], @"Found a team that should not have been loaded.");

    NSString *path = em.path;
    // Reset the shared manager instance
    [EventManager setSharedManager:nil];
    
    // Delete the state from disk.
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:&error];
    }
    
    STAssertNil(error, @"Got an error when removing %@: %@", path, error);
    
    em = [EventManager sharedManager];
    
    STAssertEquals((NSUInteger) 0, [em eventCount], @"State not properly cleared from disk.");
    
}

@end
