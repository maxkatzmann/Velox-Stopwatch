#import "VeloxFolderViewProtocol.h"
/*Velox Folder Pugin*/

static NSBundle *veloxClockBundle = nil;
static BOOL isTimerRunning = NO;

@interface VeloxStopwatchFolderView : UIView <VeloxFolderViewProtocol>
//Add properties, iVars here

@property (nonatomic, retain) UIButton *startButton;
@property (nonatomic, retain) UILabel *timerLabel;

@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, retain) NSDate *startDate;

- (void)stopTimer;
- (void)updateTimer;

@end

@implementation VeloxStopwatchFolderView

@synthesize startButton = _startButton;
@synthesize timerLabel = _timerLabel;
@synthesize timer = _timer;
@synthesize startDate = _startDate;

-(UIView *)initWithFrame:(CGRect)aFrame{
	self = [super initWithFrame:aFrame];
    if (self) {
		
        //Add subviews, load data, etc.
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        veloxClockBundle = [[NSBundle bundleForClass:[self class]] autorelease];
        
        //adding the background
        UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[veloxClockBundle pathForResource:@"stripe_background" ofType:@"png"]];
        UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:backgroundImageView];
        
        //adding buttons
        UIImage *startImage = [UIImage imageWithContentsOfFile: [veloxClockBundle pathForResource:@"start" ofType:@"png"]];
        CGFloat buttonProportion = startImage.size.height / startImage.size.width;
        CGSize buttonSize = CGSizeMake(self.frame.size.width / 2.3, buttonProportion * (self.frame.size.width / 2.3));
        
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setBackgroundImage:startImage forState:UIControlStateNormal];
        _startButton.frame = CGRectMake(self.frame.size.width / 4 - buttonSize.width / 2, self.frame.size.height * .75 - buttonSize.height / 2, buttonSize.width, buttonSize.height);
        [_startButton addTarget:self action:@selector(startWatch) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_startButton];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setBackgroundImage:[UIImage imageWithContentsOfFile: [veloxClockBundle pathForResource:@"clear" ofType:@"png"]] forState:UIControlStateNormal];
        clearButton.frame = CGRectMake(self.frame.size.width * .75 - buttonSize.width / 2, self.frame.size.height * .75 - buttonSize.height / 2, buttonSize.width, buttonSize.height);
        [clearButton addTarget:self action:@selector(clearWatch) forControlEvents:UIControlEventTouchDown];
        [self addSubview:clearButton];
        
        //adding the label
        _timerLabel = [[[UILabel alloc] init] retain];
        _timerLabel.backgroundColor = [UIColor clearColor];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.textColor = [UIColor whiteColor];
        _timerLabel.text = @"00:00.0";
        _timerLabel.font = [UIFont systemFontOfSize:50];
        [_timerLabel sizeToFit];
        _timerLabel.frame = CGRectMake(self.frame.size.width / 2 - _timerLabel.frame.size.width / 2, self.frame.size.height / 4 - _timerLabel.frame.size.height / 2 + self.frame.size.height * 0.05, _timerLabel.frame.size.width, _timerLabel.frame.size.height);
        
        [self addSubview:_timerLabel];
        
        [pool drain];
    }
    return self;
}

//what happens, when the start button is pressed
- (void)startWatch {
    if (!isTimerRunning) {
        
        isTimerRunning = YES;
        [_startButton setBackgroundImage:[UIImage imageWithContentsOfFile: [veloxClockBundle pathForResource:@"stop" ofType:@"png"]] forState:UIControlStateNormal];
        _startDate = [[NSDate date] retain];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES];
        
    } else {
        [self stopTimer];
    }
}

- (void)stopTimer {
    isTimerRunning = NO;
    [_startButton setBackgroundImage:[UIImage imageWithContentsOfFile: [veloxClockBundle pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];
    [_timer invalidate];
    _timer = nil;
    [self updateTimer];
}

//what happens, when the clear button is pressed
- (void)clearWatch {
    [self stopTimer];
    _timerLabel.text = @"00:00.0";
}

//what happens, when the timer is updated
- (void)updateTimer {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:_startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    _timerLabel.text = timeString;
}

+(int)folderHeight{
    return 150; //Make folder bigger on i5 devices?
}

@end