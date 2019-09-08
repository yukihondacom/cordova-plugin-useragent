#import "UserAgent.h"
#import "AppDelegate.h"
#import <Cordova/CDVPluginResult.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVUserAgentUtil.h>

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
    WKWebView* dummyWebView = [WKWebView new];
    dummyWebView = [WKWebView new]; // デフォルトのUserAgentを取得するための別インスタンスを作る
    [dummyWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError* error) {
        id newUserAgent = [command argumentAtIndex:0];
        self.webView.customUserAgent = newUserAgent;
        
        NSString* callbackId = command.callbackId;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:newUserAgent];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }];
    // [CDVUserAgentUtil acquireLock:^(NSInteger lockToken) {
    //     NSString* newUserAgent = [command argumentAtIndex:0];
    //     AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //     appDelegate.viewController.baseUserAgent = newUserAgent;
    //     self.webView.customUserAgent = (UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? "") + "/" + newUserAgent;
    //     [CDVUserAgentUtil setUserAgent:newUserAgent lockToken:lockToken];
    //     [CDVUserAgentUtil releaseLock:&lockToken];
        
    //     NSString* callbackId = command.callbackId;
    //     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:newUserAgent];
    //     [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    // }];
    
    // [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError* error) {
    //     id newUserAgent = [command argumentAtIndex:0];
    //     self.webView.customUserAgent = newUserAgent;
        
    //     NSString* callbackId = command.callbackId;
    //     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:newUserAgent];
    //     [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    // }];
    
}

- (void)reset: (CDVInvokedUrlCommand*)command
{
    self.webView.customUserAgent = nil;
    [self get:command];
}

@end
