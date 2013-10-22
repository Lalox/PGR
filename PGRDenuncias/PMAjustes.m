//
//  AjustesVC.m
//  PGRProtocolosDemo
//
//  Created by Juan Manuel on 15/10/13.
//  Copyright (c) 2013 Juan Manuel. All rights reserved.
//

#import "PMAjustes.h"

@interface PMAjustes ()
@property IBOutlet UITextField *tfIP;
@end

@implementation PMAjustes

@synthesize tfIP;

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
	tfIP.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"URL_AUDIO_PGR"];
	
	UIBarButtonItem *btnGuardar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(guardarIP:)];
	
	[self.navigationItem setRightBarButtonItem:btnGuardar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)guardarIP:(id)sender{
	[[NSUserDefaults standardUserDefaults] setObject:self.tfIP.text forKey:@"URL_AUDIO_PGR"];

	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	return YES;
	
}

@end
