import Foundation
import UIKit

class TopNavigationChoiceViewController: BaseViewController {
  
  @IBOutlet weak var createNewSiteButton: UIButton!
  
  @IBOutlet weak var addNewMeasurementButton: UIButton!
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
    
    createNewSiteButton.roundedButton()
    addNewMeasurementButton.roundedButton()
    
    navigationController?.navigationBar.isHidden = true
    
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
    
    switch sender {
      
    case createNewSiteButton:
      vcm?.performSegue(
        self,
        from: .topNavigationChoice,
        to: .createNewSite)
      
    case addNewMeasurementButton:
      vcm?.performSegue(
        self,
        from: .topNavigationChoice,
        to: .addNewMeasurement)
      
    default:
      LOG.error("Unexpected button")
      
    }
    
  }
}
