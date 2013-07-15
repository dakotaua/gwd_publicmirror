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
@end


@implementation QuizEvent


-(id)init {
    
    self = [super init];
    if (self)
        _quizDate = [NSDate date];
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
