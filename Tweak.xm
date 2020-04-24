@interface CCUIToggleModule : NSObject

@end

@interface CCUIToggleViewController
  @property (assign,nonatomic) CCUIToggleModule * module;
  @property (nonatomic,readonly) BOOL providesOwnPlatter;
@end

@interface SpringBoard : UIApplication
  -(void)showPowerDownAlert;
@end

@interface SBMainWorkspace
  +(id)sharedInstance;
  -(void)presentPowerDownTransientOverlay;
@end

@interface UITouchesEvent : UIEvent
  -(id)allTouches;
@end

//static BOOL isEnabled = YES;
//static CGFloat minHoldDuration = 0.8;

//NSDictionary *pref = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.imkpatil.cclinker.plist"];

%hook CCUIToggleViewController


  -(BOOL)shouldFinishTransitionToExpandedContentModule
  {
      if ([self.module isKindOfClass:NSClassFromString(@"CCUILowPowerModule")])
      {
         if (kCFCoreFoundationVersionNumber < 1600)
         {
           //< iOS12
          [(SpringBoard *)[%c(SpringBoard) sharedApplication] showPowerDownAlert];
         }
         else
         {
          [[%c(SBMainWorkspace) sharedInstance] presentPowerDownTransientOverlay];
         }
        return NO;
      }

      return %orig;
  }

  // -(void)buttonTapped:(id)arg1 forEvent:(UITouchesEvent *)arg2
  // {
  //
  //   if ([self.module isKindOfClass:NSClassFromString(@"CCUILowPowerModule")])
  //   {
  //     NSSet *touches = [arg2 allTouches];
  //     UITouch *touch = [touches anyObject];
  //
  //     if (touch.force >= 0.75)
  //     {
  //       [(SpringBoard *)[%c(SpringBoard) sharedApplication] showPowerDownAlert];
  //       return;
  //     }
  //   }
  //
  //   %orig;
  // }

%end

// %hook CCUIContentModuleContainerView
//
// -(id)initWithModuleIdentifier:(id)arg1 options:(unsigned long long)arg2
// {
//   if (isEnabled && ([self.moduleIdentifier isEqualToString:@"com.apple.control-center.LowPowerModule"]))
//   {
//     UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
//     initWithTarget:self action:@selector(handleLongPress:)];
//     longPressGestureRecognizer.minimumPressDuration = minHoldDuration;
//     [self addGestureRecognizer:longPressGestureRecognizer];
//     [longPressGestureRecognizer release];
//   }
//
//   return %orig;
// }
//
// %new
// -(void)handleLongPress:(UILongPressGestureRecognizer *)gesture
// {
//   if (gesture.state == UIGestureRecognizerStateBegan)
//   {
//     [(SpringBoard *)[%c(SpringBoard) sharedApplication] showPowerDownAlert];
//   }
//
// }

//%end
