import Foundation
import SwiftValidator
import UIKit

class LoginToAccountViewController: BaseContentViewScrollable {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var emailAddressErrorLabel: UILabel!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    loginButton.rounded()
    
    validator.registerField(
      emailAddressTextField,
      errorLabel: emailAddressErrorLabel,
      rules: [RequiredRule(), EmailRule()])
    validator.registerField(
      passwordTextField,
      errorLabel: passwordErrorLabel,
      rules: [RequiredRule()])
    
  }
  
  @IBAction func backButtonTouchUpInside() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func loginButtonTouchUpInside() {
    validator.defaultValidate(validationSuccessful)
  }

  /*
  override func viewDidLayoutSubviews() {

    scrollView.isScrollEnabled =
      contentView.frame.width >= UIScreen.main.bounds.width ||
        contentView.frame.height >= UIScreen.main.bounds.height -
          topBarHeightConstraint.constant
    scrollView.contentSize = CGSize(
      width: contentView.frame.width,
      height: contentView.frame.height)

  }
  */

  private func validationSuccessful() {
    
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    
    viewControllerManager.login(
      email: email,
      password: password,
      preAsyncBlock: preAsyncUIOperation,
      postAsyncBlock: postAsyncUIOperation)
    
  }
  
}
