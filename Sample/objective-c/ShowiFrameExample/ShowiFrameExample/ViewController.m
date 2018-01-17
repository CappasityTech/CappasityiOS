
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *skuField;

@property (weak, nonatomic) IBOutlet CappasityModelView *modelView;

@property CappasityModel *model;
@property CappasityService *service;

@property UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

-(BOOL)shouldAutorotate {
    return false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _service = [[CappasityService alloc] initWithDelegate:self];
    [_service loginWith:@""]; //enter your token
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_activityIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_modelView stopLoading];
}

- (IBAction)findButtonTapped:(UIButton *)sender {
    NSString* sku = [_skuField text];
    if (sku != nil && [sku length] > 0) {
        [_activityIndicator startAnimating];
        
        _model = [[CappasityModel alloc] initWithSku:sku delegate:self];
        [_model receiveInfo];
    }
}

- (NSString * _Nonnull)replace: (NSString * _Nonnull)embedCode :(NSString * _Nonnull) substring :(NSString * _Nonnull) value {
    return [embedCode stringByReplacingOccurrencesOfString:substring withString:value];
}

//MARK: - CappasityModelDelegate method
- (void)cappasityErrorWithCode:(NSInteger)code description:(NSString * _Nonnull)description { 
    [_activityIndicator stopAnimating];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:description
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//MARK: - CappasityModelDelegate method
- (void)cappasityMessage:(NSString * _Nonnull)message { 
    
}

//MARK: - CappasityModelDelegate method
- (void)modelInfoReceived {
    [_activityIndicator stopAnimating];
    
    CappasityModelViewParams *params = [[CappasityModelViewParams alloc] init];
    params.autoRun = true;
    [_modelView setWithModel:_model params:params];
}

//MARK: - CappasityServiceDelegate method
- (void)loginCompleted {
    
}

@end
