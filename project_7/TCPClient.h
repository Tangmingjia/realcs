//
//  TCPClient.h
//  Unity-iPhone
//
//  Created by 66-admin on 16/8/25.
//
//

#import <Foundation/Foundation.h>

@interface TCPClient : NSObject

@property (nonatomic, assign) int clientSocket;
@property (nonatomic, assign) int result;

+ (TCPClient *)shareTCPClient;

//域名 eg:www.baidu.com   端口:8080
- (BOOL)connection:(NSString *)hostText port:(int)port;

- (void)sendStringToServerAndReceived:(NSString *)message;

- (void)disConnection;

@end
