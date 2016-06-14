//
//  ViewController.m
//  JavaScript_Demo
//
//  Created by admin on 16/6/14.
//  Copyright © 2016年 AlezJi. All rights reserved.
//
//http://www.jianshu.com/p/fd378c6d70c0
//iOS开发-基于原生JS与OC方法互相调用并传值（附HTML代码）

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //webView
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    
    //加载本地的tml
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]] ;
    [self.webView loadRequest:request];

    
}

//webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    /*
     JSContext：给JavaScript提供运行的上下文环境
     JSValue：JavaScript和Objective-C数据和方法的桥梁
     JSExport：这是一个协议，如果采用协议的方法交互，自己定义的协议必须遵守此协议
     */
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"tianbai"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}


- (void)call{
    // 之后在回调js的方法Callback把内容传出去
    JSValue *Callback = self.jsContext[@"Callback"];
    //传值给web端
    [Callback callWithArguments:@[@"唤起本地OC回调完成"]];
}


- (void)getCall:(NSString *)callString{
    NSLog(@"Get:%@", callString);
    // 成功回调js的方法Callback
//    JSValue *Callback = self.jsContext[@"alerCallback"];
//    [Callback callWithArguments:nil];
    
    //    直接添加提示框
    NSString *str = @"alert('OC添加JS提示成功')";
    [self.jsContext evaluateScript:str];
    
}



@end
