#import "MenubarController.h"
#import "StatusItemView.h"
#import <Firebase/Firebase.h>

@implementation MenubarController

@synthesize statusItemView = _statusItemView;

#pragma mark -

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        NSSize newSize;
        newSize.width=16;
        newSize.height=16;
        
        // Create a referencez` to a Firebase location
        Firebase* fb = [[Firebase alloc] initWithUrl:@"https://blazing-fire-1988.firebaseio.com/"];
        // Write data to Firebase
        
        //fbRead data and react to changes
        [fb observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if(snapshot.value == [NSNull null]) {
                NSLog(@"User name doesn't exist");
            } else {
                NSString* status = snapshot.value[@"currentStatus"];
                NSLog(@"NewStatus is: %@", status);
                [self updateImage:status];
            }
        }];
        [fb setValue:@{
                            @"currentStatus": @"health-00to19",
                            @"builds":@[
                            @{
                                @"number":@"1",
                                @"status":@"success",
                                @"description": @"build"
                                },
                            @{
                                @"number":@"2",
                                @"status":@"fail",
                                @"description": @"build2"
                                },
                            ]
                       }];
        
        // Install status item into the menu bar
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem];
        //NSImage image = [NSImage imageNamed:@"appointment-recurring"];
        _statusItemView.image = [self imageResize:[NSImage imageNamed:@"health-00to19"] newSize:newSize];
        _statusItemView.alternateImage = [NSImage imageNamed:@"health-00to19"];
        _statusItemView.action = @selector(togglePanel:);
    }
    return self;
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

-(void)updateImage:(NSString*)anImage{
    NSSize newSize;
    newSize.width=16;
    newSize.height=16;
    
    // Update status item into the menu bar
    _statusItemView.image = [self imageResize:[NSImage imageNamed:anImage] newSize:newSize];
    _statusItemView.alternateImage = [NSImage imageNamed:anImage];
    _statusItemView.action = @selector(togglePanel:);

}

- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
        NSLog(@"Invalid Image");
    } else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

#pragma mark -
#pragma mark Public accessors

- (NSStatusItem *)statusItem
{
    return self.statusItemView.statusItem;
}

#pragma mark -

- (BOOL)hasActiveIcon
{
    return self.statusItemView.isHighlighted;
}

- (void)setHasActiveIcon:(BOOL)flag
{
    self.statusItemView.isHighlighted = flag;
}

@end
