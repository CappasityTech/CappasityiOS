
import UIKit

class AlertMessage {
    
    static func a(viewController: UIViewController?, title: String?, message: String, handler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        
        let ok = UIAlertAction(title: NSLocalizedString("Ok", comment: "button"), style: .cancel, handler: {_ in
            guard let handler = handler else { return }
            handler()
        })
        alert.addAction(ok)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
