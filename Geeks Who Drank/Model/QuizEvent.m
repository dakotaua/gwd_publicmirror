//
//  QuizEvent.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizEvent.h"

@interface QuizEvent()

@property (readwrite, nonatomic) NSDate *quizDate;
@property (readwrite, strong, nonatomic) NSDictionary *jsonDict;

@end


@implementation QuizEvent

-(NSDictionary *)jsonDict {
    _jsonDict = @{
             @"event_id": [NSNumber numberWithInt:1],
             @"venue_id": [NSNumber numberWithInt:1],
        @"quizmaster_id": [NSNumber numberWithInt:1],
            @"quiz_date": self.quizDate.description,
              @"quizzes": [[NSMutableArray alloc] init]
    };
    
    // TODO: Get Event ID
    
    // TODO: Get Venue ID
    
    // TODO: Get QuizMaster ID
    
    for (id q in self.quizzes) {
        if ([q isMemberOfClass:[Quiz class]]) {
            Quiz *quiz = (Quiz *) q;
            
            [_jsonDict[@"quizzes"] addObject:quiz.jsonDict];
        }
    }
    
    return _jsonDict;
}

-(NSDictionary *)serialize {
    NSMutableArray *quizzes = [[NSMutableArray alloc] init];
    
    for (Quiz *quiz in self.quizzes) {
        [quizzes addObject:[quiz serialize]];
    }
    
    return @{@"quizMaster":self.quizMaster,
             @"location":self.location,
             @"quizDate":self.quizDate,
             @"quizzes":quizzes};
}

-(id)init {
    
    self = [super init];
    if (self)
        _quizDate = [NSDate date];
    return self;
}

-(id)initWithTempValues {
    self = [self init];
    self.quizMaster = @"Temp Quiz Master String";
    self.location = @"Temp Location String";
    
    return self;
}


-(NSString *)quizMaster {
    
    if(!_quizMaster) _quizMaster = @"";
    return _quizMaster;
}

//-(NSString *)location {
//
//    if(!_location) _location = @"";
//    return _location;
//}


-(NSMutableArray *)quizzes {

    if (!_quizzes) _quizzes = [[NSMutableArray alloc] init];
    return _quizzes;
}

-(NSOrderedSet *)standings {
    
    if (!_standings) _standings = [[NSOrderedSet alloc] init];
    return _standings;
}

-(void)uploadEvent {
    
}

@end
