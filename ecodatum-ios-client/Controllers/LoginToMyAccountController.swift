import UIKit
import SwiftValidator

class LoginToMyAccountController: UIViewController {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var emailAddressErrorLabel: UILabel!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private let validator = Validator()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    loginButton.roundedButton()
    
    func successStyleTransformer(rule: ValidationRule) {
      
      let textField = rule.field as! UITextField
      textField.layer.borderColor = UIColor.green.cgColor
      textField.layer.borderWidth = 0.5
      rule.errorLabel?.text = nil
      rule.errorLabel?.isHidden = true
      
    }
    
    func errorStyleTransformer(error: ValidationError) {
      
      let textField = error.field as! UITextField
      textField.layer.borderColor = UIColor.red.cgColor
      textField.layer.borderWidth = 1.0
      error.errorLabel?.text = error.errorMessage
      error.errorLabel?.isHidden = false
      
    }
    
    validator.styleTransformers(
      success: successStyleTransformer,
      error: errorStyleTransformer)
    
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
    validator.validate(self)
  }
  
}

extension LoginToMyAccountController: ValidationDelegate {
  
  func validationSuccessful() {
    
    func updateUI(isEnabled: Bool = true,
                  showActivityIndicator: Bool = false,
                  error: Error? = nil) {
      
      emailAddressTextField.isEnabled = isEnabled
      passwordTextField.isEnabled = isEnabled
      loginButton.isEnabled = isEnabled
      if showActivityIndicator {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
      
      if error != nil {
        
        let alert = UIAlertController(
          title: "Login Failure",
          message: "Unrecognized email address and/or password.",
          preferredStyle: .alert)
        alert.addAction(
          UIAlertAction(
            title: "OK",
            style: .default))
        present(alert,
                animated: true,
                completion: nil)
        
      }
      
    }
    
    updateUI(isEnabled: false, showActivityIndicator: true)
    
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    ControllerManager.shared.login(email: email, password: password)
      .then(in: .main) {
        loginResponse in
        LOG.debug(loginResponse)
        // TODO: segue to the next page
      }.catch(in: .main) {
        error in
        LOG.error(error)
        updateUI(error: error)
    }
    
  }
  
  func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    // validation failures are handled with validator styleTransformers above
  }
  
}


