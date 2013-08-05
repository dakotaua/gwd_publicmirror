//
//  Quiz.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/1/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "Quiz.h"
#import "Constants.h"

@interface Quiz()

@property (readwrite, strong, nonatomic) NSDictionary *jsonDict;

@end

@implementation Quiz

-(NSDictionary *)jsonDict {
    _jsonDict = @{
          @"team_name": self.teamName,
        @"joker_round": [NSNumber numberWithInt:self.jokerRound],
             @"rounds": [[NSMutableArray alloc] init]
    };
    
    for (id r in self.quizRounds) {
        if ([r isMemberOfClass:[QuizRound class]]) {
            QuizRound *quizRound = (QuizRound *) r;
            
            [_jsonDict[@"rounds"] addObject:quizRound.jsonDict];
        }
    }
    
    return _jsonDict;
}

-(NSDictionary *)serialize {
    NSMutableArray *quizRounds = [[NSMutableArray alloc] init];
    
    for (QuizRound *quizRound in self.quizRounds) {
        [quizRounds addObject:[quizRound serialize]];
    }
    
    return @{@"teamName":self.teamName,
             @"jokerRound":[NSNumber numberWithInt:self.jokerRound],
             @"quizRounds":quizRounds};
}

-(NSComparisonResult)reverseCompare:(Quiz *)otherQuiz{
    NSNumber* myScore = [NSNumber numberWithInt:[self quizScore]];
    NSNumber* otherScore = [NSNumber numberWithInt:[otherQuiz quizScore]];
    return [otherScore compare:myScore];
}

-(NSComparisonResult)compare:(Quiz *)otherQuiz {
    NSNumber* myScore = [NSNumber numberWithInt:[self quizScore]];
    NSNumber* otherScore = [NSNumber numberWithInt:[otherQuiz quizScore]];
    return [myScore compare:otherScore];
}

-(NSMutableArray *)quizRounds {
    
    if (!_quizRounds) _quizRounds = [[NSMutableArray alloc] init];
    return _quizRounds;
}

-(NSString *)teamName {
    
    if (!_teamName) _teamName = @"";
    return  _teamName;
}

-(int)quizScore {
    
    int score = 0;
    
    if (self.quizRounds.count)
        for (QuizRound* r in self.quizRounds) {
            if (self.jokerRound == r.roundNumber-1 )
                score += [r roundScore]*2;
            else
                score += [r roundScore];
        }
    return score;
}

-(id)init {
    
    self = [super init];
    
    if (self) {
        for (int i = 0; i < ROUNDS_PER_QUIZ; i++) {
            QuizRound *round = [[QuizRound alloc] init];
            round.roundNumber = i+1;
            [self.quizRounds addObject:round];
        }
    }
    self.jokerRound = -1;
    return self;
}

-(id)initWithName:(NSString*)teamName {
    
    self = [self init];
    if (self)
        self.teamName = teamName;
    return self;
}

@end



