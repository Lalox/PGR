//
//  ConnectionHandler.h
//  PGRProtocolosDemo
//
//  Created by Juan Manuel on 09/10/13.
//  Copyright (c) 2013 Juan Manuel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionHandlerDelegate;

@interface PMConnectionHandler : NSObject<NSURLConnectionDataDelegate>

@property (weak) id<ConnectionHandlerDelegate>delegado;

-(void)consumeServicioURL:(NSURL *)url conAudio:(NSData *)data;

-(void)consumeServicioURL:(NSURL *)url conImagen:(NSData *)data;

@end


@protocol ConnectionHandlerDelegate <NSObject>

-(void)connectionHandler:(PMConnectionHandler *)connectionHandler terminaExitoso:(NSString *)mensaje;

-(void)connectionHandler:(PMConnectionHandler *)connectionHandler fallaConsumo:(NSString *)mensajeError;

-(void)connectionHandlerTerminaProceso:(PMConnectionHandler *)connectionHandler;

@end