//
//  PMVideoViewController.m
//  PGRDenuncias
//
//  Created by Planet Media on 20/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMVideoViewController.h"
#import "PMPantallaFinal.h"

#define _ID_VIDEO_CELL_ @"cellVideoIdentifier"

@interface PMVideoViewController (){
    //Image management variables
    NSMutableArray *videoArray;
    UIImagePickerController *pickerController;
    NSFileManager *fileManger;
    NSURL *outputFileURL;
//    AVAudioPlayer *player;
}

@end

@implementation PMVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSURL* url = [PMUtilityManager getPathWithName:@"Video.aiff"];
  //      NSError* error = nil;
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        if(!error)
//        {
//            [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
//        }
		videoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[[UIAlertView alloc] initWithTitle:@"PGR" message:@"Grabe video de inspección superficial" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
	
    [_videoList registerClass:[UITableViewCell class] forCellReuseIdentifier:_ID_VIDEO_CELL_];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:(@"Send") value:@"Enviar" table:nil] style:UIBarButtonItemStyleBordered target:self action:@selector(sendInformation:)];
}

- (void) sendInformation:(id)sender{
    if (![PMUtilityManager isThereInternetAccess]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:(@"Error") value:@"Error" table:nil] message:[[NSBundle mainBundle] localizedStringForKey:(@"NoConnection") value:@"No se detecta conexión a Internet ¿Desea continuar?" table:nil] delegate:self cancelButtonTitle:[[NSBundle mainBundle] localizedStringForKey:(@"OK") value:@"Aceptar" table:nil] otherButtonTitles:nil];
        [alert show];
    }else{
		
		[self enviarVideos];
		
		UIViewController *vc = [[PMPantallaFinal alloc] initWithNibName:@"PMPantallaFinal" bundle:nil];
		
		[self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)enviarVideos{

	for (NSString *titulo in videoArray) {

		PMConnectionHandler *conn = [[PMConnectionHandler alloc] init];
		conn.delegado = self;
		
		NSString *strUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"URL_AUDIO_PGR"];
		
		strUrl = [strUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
		strUrl = [NSString stringWithFormat:@"http://%@/pgr/recibeArchivos.php", strUrl];
		NSURL *url = [NSURL URLWithString:strUrl];
		
		NSURL *urlMedia = [PMUtilityManager getPathWithName:titulo];

		NSData *data = [NSData dataWithContentsOfURL:urlMedia];
		
		[conn consumeServicioURL:url conAudio:data titulo:(NSString *)titulo];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordVideo:(id)sender {
    
	if (pickerController == nil)
        pickerController = [[UIImagePickerController alloc] init];
	pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	pickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
	//pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	pickerController.delegate = self;
	pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;

	[self presentViewController:pickerController animated:YES completion:nil];

}

#pragma mark UITableViewDelegate and Datasource Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_ID_VIDEO_CELL_ forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[videoArray objectAtIndex:indexPath.item]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [videoArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [PMUtilityManager getPathWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    //[audioManager playWithURL:url];

	MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[url path]]];
	
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(movieFinishedCallback:)
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:[playerViewController moviePlayer]];
	
	playerViewController.view.tag = 321;
    [self.view addSubview:playerViewController.view];
	[self presentMoviePlayerViewControllerAnimated:playerViewController];
	
    //play movie
	
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    [player play];
}

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter]
	 removeObserver:self];
	
    [player stop];
	
	[self dismissMoviePlayerViewControllerAnimated];
//	[player.view removeFromSuperview];
	
}


#pragma mark UIIMagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSError *error;
    fileManger = [NSFileManager defaultManager];

    outputFileURL = [info objectForKey:UIImagePickerControllerMediaURL];
	
    NSURL *theNewURL = [PMUtilityManager getPathWithName:[NSString stringWithFormat:@"Video_%d.MOV",[videoArray count]+1]];
    
    if([fileManger fileExistsAtPath:[theNewURL path]]){
        [fileManger removeItemAtURL:theNewURL error:&error];
        if(error){
            [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
            return;
        }
    }
    [fileManger moveItemAtURL:outputFileURL toURL:theNewURL error:&error];
    if(error){
        [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
    }else{
        [videoArray addObject:[theNewURL lastPathComponent]];
        [_videoList reloadData];
    }
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark PMConnectionHandler Delegate

-(void)connectionHandler:(PMConnectionHandler *)connectionHandler fallaConsumo:(NSString *)mensajeError{
	
}

-(void)connectionHandler:(PMConnectionHandler *)connectionHandler terminaExitoso:(NSString *)mensaje{
	
}

-(void)connectionHandlerTerminaProceso:(PMConnectionHandler *)connectionHandler{
	
}

@end
