
import UIKit

class Message {
    
    static func alert(viewController: UIViewController?, title: String?, message: String, handler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
        
        let ok = UIAlertAction(title: NSLocalizedString("Ok", comment: "button"), style: .cancel, handler: {_ in
            guard let handler = handler else { return }
            handler()
        })
        alertController.addAction(ok)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
