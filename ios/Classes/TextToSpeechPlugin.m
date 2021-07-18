#import "TextToSpeechPlugin.h"
#if __has_include(<text_to_speech/text_to_speech-Swift.h>)
#import <text_to_speech/text_to_speech-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "text_to_speech-Swift.h"
#endif

@implementation TextToSpeechPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTextToSpeechPlugin registerWithRegistrar:registrar];
}
@end
