//
//  PMPrincipalViewController.m
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMPrincipalViewController.h"
#import "PMAjustes.h"

@interface PMPrincipalViewController (){
    PMAudioManager *audioManager;
}

@end

@implementation PMPrincipalViewController

#pragma mark Default Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Set audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"Reporte_Inicial.caf",
                                   nil];
        
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        audioManager = [[PMAudioManager alloc] init];
        audioManager.delegate = self;
        [audioManager prepareRecordingWithURL:outputFileURL];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Controls Methods

- (IBAction)recordAudio:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (btn.selected){
        [btn setSelected:NO];
        [audioManager stopPlayingRecording];
    }else{
        [btn setSelected:YES];
        [audioManager startRecording];
    }
}

-(IBAction)ponPantallaAjustes:(id)sender{
	UIViewController *ajustes = [[PMAjustes alloc] initWithNibName:@"PMAjustes" bundle:nil];
	
	[self.navigationController pushViewController:ajustes animated:YES];
}


#pragma mark PMAudioManagerDelegate Methods

- (void)finishRecordingPlayingWithAudioUrl:(NSURL *)url{

//	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(enviarPrimerReporte:) object:url];
//	NSOperationQueue *opQ = [[NSOperationQueue alloc] init];
//	[opQ addOperation:op];
	[self enviarPrimerReporte:url];
	
    PMEvidenciasViewController *evidencias = [[PMEvidenciasViewController alloc] initWithNibName:@"PMEvidenciasViewController" bundle:nil];
    [self.navigationController pushViewController:evidencias animated:YES];
			
}

-(void)enviarPrimerReporte:(NSURL *)urlAudio{
	PMConnectionHandler *connection = [[PMConnectionHandler alloc] init];
	connection.delegado = self;
	
	NSString *strUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"URL_AUDIO_PGR"];
	
	strUrl = [strUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	strUrl = [NSString stringWithFormat:@"http://%@/pgr/recibeArchivos.php", strUrl];
	
	NSURL *url = [NSURL URLWithString:strUrl];
	
	[connection consumeServicioURL:url conAudio:[NSData dataWithContentsOfURL:urlAudio]];
}

#pragma mark PMConnectionHandler Delegate
-(void)connectionHandler:(PMConnectionHandler *)connectionHandler fallaConsumo:(NSString *)mensajeError{
	
}

-(void)connectionHandler:(PMConnectionHandler *)connectionHandler terminaExitoso:(NSString *)mensaje{
	
}

-(void)connectionHandlerTerminaProceso:(PMConnectionHandler *)connectionHandler{
	
}


@end
