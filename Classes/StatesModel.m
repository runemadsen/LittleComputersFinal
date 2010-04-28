#import "StatesModel.h"

@implementation StatesModel

@synthesize names = _names;

+ (NSMutableArray *)theNames 
{
    return [NSMutableArray arrayWithObjects:
			@"a",
			@"b",
			@"c",
			@"d",
			@"e",
			@"f",
			@"g",
			@"h",
			@"i",
			@"j",
			@"k",
			@"l",
			@"m",
			@"n",
			@"o",
			@"p",
			@"q",
			@"r",
			@"s",
			@"t",
			@"u",
			@"v",
			@"w",
			@"x",
			@"y",
			@"z",
			@"A",
			@"B",
			@"C",
			@"D",
			@"E",
			@"F",
			@"G",
			@"H",
			@"I",
			@"J",
			@"K",
			@"L",
			@"M",
			@"N",
			@"O",
			@"P",
			@"Q",
			@"R",
			@"S",
			@"T",
			@"U",
			@"V",
			@"W",
			@"X",
			@"Y",
			@"Z",
			@"Tab",
			@"Caps Lock",
			@"Shift",
			@"fn",
			@"Control",
			@"Alt / Option",
			@"Command",
			@"Space",
			@"Right Arrow",
			@"Left Arrow",
			@"Up Arrow",
			@"Down Arrow",
			@"Enter",
			@"Delete",
			@"F1",
			@"F2",
			@"F3",
			@"F4",
			@"F5",
			@"F6",
			@"F7",
			@"F8",
			@"F9",
			@"F10",
			@"F11",
			@"F12",
            nil];
}

- (id)initWithNames:(NSArray *)names 
{
    if (self = [super init]) 
	{
        _delegates = nil;
        _allNames = [names copy];
        _names = nil;
    }
	
    return self;
}

- (void)dealloc 
{
    TT_RELEASE_SAFELY(_delegates);
    TT_RELEASE_SAFELY(_allNames);
    TT_RELEASE_SAFELY(_names);
    
	[super dealloc];
}


- (void)loadNames 
{
    TT_RELEASE_SAFELY(_names);
    _names = [_allNames mutableCopy];
}

- (void)search:(NSString*)text 
{
    [self cancel];
    
    self.names = [NSMutableArray array];
    
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
    
    if (text.length) {
        text = [text lowercaseString];
        for (NSString *state in _allNames) {
            if ([[state lowercaseString] rangeOfString:text].location == 0) {
                [_names addObject:state];
            }
        }    
    }
    
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

#pragma mark -
#pragma mark TTModel methods

- (NSMutableArray *)delegates {
    if (!_delegates) {
        _delegates = TTCreateNonRetainingArray();
    }
    return _delegates;
}

- (BOOL)isLoadingMore {
    return NO;
}

- (BOOL)isOutdated {
    return NO;
}

- (BOOL)isLoaded {
    return !!_names;
}

- (BOOL)isLoading {
    return NO;
}

- (BOOL)isEmpty {
    return !_names.count;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}

- (void)invalidate:(BOOL)erase {
}

- (void)cancel {
}

@end
