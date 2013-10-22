//
//  PMInicialVC.m
//  PGRDenuncias
//
//  Created by Juan Manuel on 21/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMInicialVC.h"
#import "PMPrincipalViewController.h"

@interface PMInicialVC ()

@end

@implementation PMInicialVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Iniciar" style:UIBarButtonItemStyleBordered target:self action:@selector(iniciaProtocolo:)];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PGR"]];
	[imageView sizeToFit];
	imageView.center = self.navigationController.navigationBar.center;
	
	[self.navigationController.view addSubview:imageView];
	
	[[[UIAlertView alloc] initWithTitle:@"PGR" message:@"Se ha recibido una denuncia" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
}


-(void)iniciaProtocolo:(id)sender{
	
	UIViewController *vc = [[PMPrincipalViewController alloc] initWithNibName:@"PMPrincipalViewController" bundle:nil];
	
	[self.navigationController pushViewController:vc animated:YES];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
