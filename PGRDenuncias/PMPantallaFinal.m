//
//  PMPantallaFinal.m
//  PGRDenuncias
//
//  Created by Juan Manuel on 21/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMPantallaFinal.h"

@interface PMPantallaFinal ()

@end

@implementation PMPantallaFinal

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
	[[[UIAlertView alloc] initWithTitle:@"PGR" message:@"Notifique a otras dependencias (de ser necesario)" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)setSelected:(id)sender{

	[(UIButton *)sender setSelected:![sender isSelected]];
}

-(IBAction)inicio:(id)sender{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
