
import UIKit
import Cappasity

class ViewController: UIViewController {
    
    @IBOutlet weak var skuField: UITextField!
    @IBOutlet weak var modelView: CappasityModelView!
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .gray

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(activityIndicator)
        self.view.bringSubview(toFront: activityIndicator)
        
        NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        return activityIndicator
    }()

    fileprivate var model: CappasityModel?
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.skuField.placeholder = "Enter sku"
        
        self.modelView.delegate = self
        self.modelView.viewController = self
        
        initGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.modelView.stopLoading()
    }
    
    @IBAction func findButtonTapped(_ sender: UIButton) {
        if let sku = skuField?.text {
            self.model = CappasityModel(withSku: sku, delegate: self)
            self.model?.receiveInfo()
            self.activityIndicator.startAnimating()
        }
    }
    
    private func initGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension ViewController: CappasityModelDelegate {
  
    //MARK: - CappasityModelDelegate method
    func capService(didReceive error: Int, description: String) {
        self.activityIndicator.stopAnimating()
        Message.alert(viewController: self, title: "Error", message: description, handler: nil)
    }
    
    //MARK: - CappasityModelDelegate method
    func capServiceDidReceiveModelInfo() {
        if let model = self.model {
            self.modelView.set(model, autoRun: true)
        }
    }
    
    //MARK: - CappasityModelDelegate method
    func capService(didReceive preview: UIImage, userInfo: AnyObject?) {
        
    }
}

extension ViewController: CappasityModelViewDelegate {
    
    //MARK: - CappasityModelViewDelegate method
    func capServiceDidLoadContent() {
        self.activityIndicator.stopAnimating()
    }
}
