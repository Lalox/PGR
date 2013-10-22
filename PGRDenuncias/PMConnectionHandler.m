//
//  ConnectionHandler.m
//  PGRProtocolosDemo
//
//  Created by Juan Manuel on 09/10/13.
//  Copyright (c) 2013 Juan Manuel. All rights reserved.
//

#import "PMConnectionHandler.h"

@implementation PMConnectionHandler{
	NSMutableData *_recivedData;
	
	NSURLConnection *connection;
}

@synthesize delegado;


-(void)construyePeticion:(NSURL *)url mediaData:(NSData *)mediaData nombreArchivo:(NSString *)nombreArchivo{
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//---
	
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"archivo[]\"; filename=\"%@\"\r\n", nombreArchivo] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//---
	
	[body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:mediaData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	if (connection != nil) {
		_recivedData = [[NSMutableData alloc] init];
	} else {
		[self.delegado connectionHandler:self fallaConsumo:@"No se conecta"];
	}
	
}

-(void)consumeServicioURL:(NSURL *)url conAudio:(NSData *)audioData titulo:(NSString *)titulo{

	[self construyePeticion:url mediaData:audioData nombreArchivo:titulo];
	
}

-(void)consumeServicioURL:(NSURL *)url conImagen:(NSData *)data titulo:(NSString *)titulo{

	[self construyePeticion:url mediaData:data nombreArchivo:titulo];
	
}

#pragma NSUrlConnection Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[_recivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[_recivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[self.delegado connectionHandler:self fallaConsumo:error.description];
	[self.delegado connectionHandlerTerminaProceso:self];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

	NSString *msg = [[NSString alloc] initWithData:_recivedData encoding:NSUTF8StringEncoding];
	[self.delegado connectionHandler:self terminaExitoso:msg];

	[self.delegado connectionHandlerTerminaProceso:self];
}

@end
