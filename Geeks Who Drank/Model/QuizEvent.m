//
//  QuizEvent.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizEvent.h"

@implementation QuizEvent

-(NSMutableArray *)quizzes {

    if (!_quizzes) _quizzes = [[NSMutableArray alloc] init];
    return _quizzes;
}

-(NSOrderedSet *)standings {
    
    if (!_standings) _standings = [[NSOrderedSet alloc] init];
    return _standings;
}

-(NSString *)quizMaster {
    
    if(!_quizMaster) _quizMaster = @"";
    return _quizMaster;
}

@end
