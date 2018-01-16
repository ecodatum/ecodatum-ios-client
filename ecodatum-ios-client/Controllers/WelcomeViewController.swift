import Foundation
import UIKit

class WelcomeViewController: BaseViewController {
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var newAccountButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    LOG.debug("WelcomeViewController.viewDidLoad")
    
    loginButton.roundedButton()
    newAccountButton.roundedButton()
    
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
      
    case loginButton:
      vcm?.performSegue(self, from: .welcome, to: .loginToAccount)
      
    case newAccountButton:
      vcm?.performSegue(self, from: .welcome, to: .createNewAccount)
      
    default:
      LOG.warning("Unrecognized button: \(sender)")
      
    }
    
  }
  
}

