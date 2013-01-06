//
//  MarquetteViewController.m
//  Marquette
//
//  Created by Nicholas Humfrey on 15/01/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MarquetteViewController.h"
#import "MarquetteAppDelegate.h"
#import "MosquittoClient.h"

@implementation MarquetteViewController

@synthesize redLedSwitch;
@synthesize greenLedSwitch;
@synthesize hostField;
@synthesize connectButton;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"View Did Load");
    MarquetteAppDelegate *myAppDelegate = (MarquetteAppDelegate *)[UIApplication sharedApplication].delegate;
    [myAppDelegate.mosquittoClient setDelegate:self];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSLog(@"View Did Load");
    MarquetteAppDelegate *myAppDelegate = (MarquetteAppDelegate *)[UIApplication sharedApplication].delegate;
    [myAppDelegate.mosquittoClient setDelegate:self];
    [super viewDidLoad];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction) redLedSwitchAction:(id)sender {
	MarquetteAppDelegate *app = [[UIApplication sharedApplication] delegate];
	MosquittoClient *mosq = [app mosquittoClient];
    if ([sender isOn]) {
        NSLog(@"Red LED On");
		[mosq publishString:@"1" toTopic:@"nanode/red_led" retain:YES];
    }
    else {
        NSLog(@"Red LED Off");
		[mosq publishString:@"0" toTopic:@"nanode/red_led" retain:YES];
    }
}

- (IBAction) greenLedSwitchAction:(id)sender {
	MarquetteAppDelegate *app = [[UIApplication sharedApplication] delegate];
	MosquittoClient *mosq = [app mosquittoClient];
    if ([sender isOn]) {
        NSLog(@"Green LED On");
		[mosq publishString:@"1" toTopic:@"nanode/green_led" retain:YES];
    }
    else {
        NSLog(@"Green LED Off");
		[mosq publishString:@"0" toTopic:@"nanode/green_led" retain:YES];
    }
}

- (IBAction) connectButtonAction:(id)sender {
	MarquetteAppDelegate *app = [[UIApplication sharedApplication] delegate];
	MosquittoClient *mosq = [app mosquittoClient];

	// (Re-)connect
	//[mosq disconnect]; UITextField
	[mosq setHost: [[self hostField] text]];
	[mosq connect];

	[mosq subscribe:@"nanode/red_led"];
	[mosq subscribe:@"nanode/green_led"];
}

- (void) didConnect:(NSUInteger)code {
    NSLog(@"didConnect");
	[[self connectButton] setTitle:@"Reconnect" forState:UIControlStateNormal];
}

- (void) didDisconnect {
	[[self connectButton] setTitle:@"Connect" forState:UIControlStateNormal];
}

- (void) didReceiveMessage: (MosquittoMessage *)message {
	NSLog(@"ReceivedMessage: %@ => %@", [message topic], [message payload]);

	UISwitch *sw = nil;
	if ([[message topic] isEqualToString:@"nanode/red_led"]) {
		sw = redLedSwitch;
	} else if ([[message topic] isEqualToString:@"nanode/green_led"]) {
		sw = greenLedSwitch;
	} else {
		return;
	}

	if ([[message payload] isEqualToString:@"1"]) {
		[sw setOn: YES];
	} else if ([[message payload] isEqualToString:@"0"]) {
		[sw setOn: NO];
	}
}

- (void) didPublish: (NSUInteger)messageId {
    NSLog(@"didPublish");
}

- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos {
    NSLog(@"didSubscribe");
}

- (void) didUnsubscribe: (NSUInteger)messageId {
    NSLog(@"didUbsubscribe");
}

- (void)dealloc {
    [super dealloc];
}

@end
