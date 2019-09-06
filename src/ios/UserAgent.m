#import "UserAgent.h"
#import <Cordova/CDVPluginResult.h>

@import WebKit;

@implementation UserAgent

- (void)get: (CDVInvokedUrlCommand*)command
{
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError* error) {
        NSString* userAgent = result;
        NSString* callbackId = command.callbackId;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:userAgent];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }];
}

- (void)set: (CDVInvokedUrlCommand*)command
{
    id newUserAgent = [command argumentAtIndex:0];
    
    WKWebView* dummyWebView = [WKWebView new]; // デフォルトのUserAgentを取得するための別インスタンスを作る
    [dummyWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError* error) {
        dummyWebView.customUserAgent = newUserAgent; // evaluateJavaScript()が完了するまでdummyWebViewが開放されないよう、クロージャ内で参照しておく
        self.webView.customUserAgent = newUserAgent;

        NSString* callbackId = command.callbackId;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:newUserAgent];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }];

}

- (void)reset: (CDVInvokedUrlCommand*)command
{
    self.webView.customUserAgent = nil;
    [self get:command];
}

@end
