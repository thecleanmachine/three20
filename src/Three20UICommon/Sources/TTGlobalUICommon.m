//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20UICommon/TTGlobalUICommon.h"

// UI
#import "Three20UICommon/UIWindowAdditions.h"

// Core
#import "Three20Core/TTGlobalCoreLocale.h"

#include <sys/types.h>
#include <sys/sysctl.h>

const CGFloat ttkDefaultRowHeight = 44.0f;

const CGFloat ttkDefaultPortraitToolbarHeight   = 44.0f;
const CGFloat ttkDefaultLandscapeToolbarHeight  = 33.0f;

const CGFloat ttkDefaultPortraitKeyboardHeight      = 216.0f;
const CGFloat ttkDefaultLandscapeKeyboardHeight     = 160.0f;
const CGFloat ttkDefaultPadPortraitKeyboardHeight   = 264.0f;
const CGFloat ttkDefaultPadLandscapeKeyboardHeight  = 352.0f;

const CGFloat ttkGroupedTableCellInset = 9.0f;
const CGFloat ttkGroupedPadTableCellInset = 42.0f;

const CGFloat ttkDefaultTransitionDuration      = 0.3f;
const CGFloat ttkDefaultFastTransitionDuration  = 0.2f;
const CGFloat ttkDefaultFlipTransitionDuration  = 0.7f;


///////////////////////////////////////////////////////////////////////////////////////////////////
float TTOSVersion() {
  return [[[UIDevice currentDevice] systemVersion] floatValue];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTOSVersionIsAtLeast(float version) {
  // Floating-point comparison is pretty bad, so let's cut it some slack with an epsilon.
  static const CGFloat kEpsilon = 0.0000001f;

#ifdef __IPHONE_4_2
  return 4.2 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_4_1
  return 4.1 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_4_0
  return 4.0 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_3_2
  return 3.2 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_3_1
  return 3.1 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_3_0
  return 3.0 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_2_2
  return 2.2 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_2_1
  return 2.1 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_2_0
  return 2.0 - version >= -kEpsilon;
#endif
  return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsKeyboardVisible() {
  // Operates on the assumption that the keyboard is visible if and only if there is a first
  // responder; i.e. a control responding to key events
  UIWindow* window = [UIApplication sharedApplication].keyWindow;
  return !![window findFirstResponder];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsPhoneSupported() {
  NSString* deviceType = [UIDevice currentDevice].model;
  return [deviceType isEqualToString:@"iPhone"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsPad() {
#ifdef __IPHONE_3_2
		return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
		return NO;
#endif
}


///////////////////////////////////////////////////////////////////////////////////////////////////
UIDeviceOrientation TTDeviceOrientation() {
  UIDeviceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
  if (UIDeviceOrientationUnknown == orient) {
    return UIDeviceOrientationPortrait;

  } else {
    return orient;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTDeviceOrientationIsPortrait() {
  UIDeviceOrientation orient = TTDeviceOrientation();

  switch (orient) {
    case UIInterfaceOrientationPortrait:
    case UIInterfaceOrientationPortraitUpsideDown:
      return YES;
    default:
      return NO;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTDeviceOrientationIsLandscape() {
  UIDeviceOrientation orient = TTDeviceOrientation();

  switch (orient) {
    case UIInterfaceOrientationLandscapeLeft:
    case UIInterfaceOrientationLandscapeRight:
      return YES;
    default:
      return NO;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* TTDeviceModelName() {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
  free(machine);

  if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
  if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
  if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
  if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
  if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (CDMA)";
  if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
  if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
  if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
  if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
  if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
  if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
  if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
  if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
  if ([platform isEqualToString:@"i386"])         return @"Simulator";

  return platform;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsSupportedOrientation(UIInterfaceOrientation orientation) {
  if (TTIsPad()) {
    return YES;

  } else {
    switch (orientation) {
      case UIInterfaceOrientationPortrait:
      case UIInterfaceOrientationLandscapeLeft:
      case UIInterfaceOrientationLandscapeRight:
        return YES;
      default:
        return NO;
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGAffineTransform TTRotateTransformForOrientation(UIInterfaceOrientation orientation) {
  if (orientation == UIInterfaceOrientationLandscapeLeft) {
    return CGAffineTransformMakeRotation(M_PI*1.5);

  } else if (orientation == UIInterfaceOrientationLandscapeRight) {
    return CGAffineTransformMakeRotation(M_PI/2);

  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
    return CGAffineTransformMakeRotation(-M_PI);

  } else {
    return CGAffineTransformIdentity;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect TTApplicationFrame() {
  CGRect frame = [UIScreen mainScreen].applicationFrame;
  return CGRectMake(0, 0, frame.size.width, frame.size.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat TTToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
  if (UIInterfaceOrientationIsPortrait(orientation) || TTIsPad()) {
    return TT_ROW_HEIGHT;

  } else {
    return TT_LANDSCAPE_TOOLBAR_HEIGHT;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat TTKeyboardHeightForOrientation(UIInterfaceOrientation orientation) {
  if (TTIsPad()) {
    return UIInterfaceOrientationIsPortrait(orientation) ? TT_IPAD_KEYBOARD_HEIGHT
                                                         : TT_IPAD_LANDSCAPE_KEYBOARD_HEIGHT;

  } else {
    return UIInterfaceOrientationIsPortrait(orientation) ? TT_KEYBOARD_HEIGHT
                                                         : TT_LANDSCAPE_KEYBOARD_HEIGHT;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat TTGroupedTableCellInset() {
  return TTIsPad() ? ttkGroupedPadTableCellInset : ttkGroupedTableCellInset;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void TTAlert(NSString* message) {
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:TTLocalizedString(@"Alert", @"")
                                             message:message delegate:nil
                                             cancelButtonTitle:TTLocalizedString(@"OK", @"")
                                             otherButtonTitles:nil] autorelease];
  [alert show];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void TTAlertNoTitle(NSString* message) {
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:TTLocalizedString(@"OK", @"")
                                         otherButtonTitles:nil] autorelease];
  [alert show];
}
