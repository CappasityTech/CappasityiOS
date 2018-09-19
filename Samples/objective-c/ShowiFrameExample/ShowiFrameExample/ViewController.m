
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *skuField;

@property (weak, nonatomic) IBOutlet CappasityModelView *modelView;

@property CappasityModel *model;

@property UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

-(BOOL)shouldAutorotate {
    return false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_activityIndicator];
    
    _modelView.delegate = self;
    _modelView.viewController = self;
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
- (void)capServiceWithDidReceive:(NSInteger)error description:(NSString * _Nonnull)description userInfo:(id _Nullable)userInfo {
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
- (void)capServiceDidReceiveModelInfo {
    CappasityModelViewParams *params = [[CappasityModelViewParams alloc] init];
    params.autoRun = true;
    [_modelView setWithModel:_model params:params];
}

//MARK: - CappasityModelViewDelegate method
- (void)capServiceWithDidReceive:(UIImage * _Nonnull)preview userInfo:(id _Nullable)userInfo {
    
}

//MARK: - CappasityModelViewDelegate method
- (void)capServiceDidLoadContent {
    [_activityIndicator stopAnimating];
}

@end
