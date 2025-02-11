import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var BMIResultLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlaceholderText()
    }
    
    @IBAction func unitChanged(_ sender: UISegmentedControl) {
        updatePlaceholderText()
    }

    @IBAction func calculateBMI(_ sender: UIButton) {
        calculateDisplayBMI()
    }
    
    func updatePlaceholderText() {
        if unitSegmentedControl.selectedSegmentIndex == 0 {
            heightTextField.placeholder = "Height (cm)"
            weightTextField.placeholder = "Weight (kg)"
        } else {
            heightTextField.placeholder = "Height (in)"
            weightTextField.placeholder = "Weight (lb)"
        }
    }
    
    func validateInput() -> (Double, Double)? {
        guard let heightText = heightTextField.text, let weightText = weightTextField.text,
              let height = Double(heightText), let weight = Double(weightText),
              height > 0, weight > 0 else {
            return nil
        }
        
        if unitSegmentedControl.selectedSegmentIndex == 0 {
            if weight > 350 || height > 285 {
                return nil
            }
        } else {
            if weight > 772 || height > 112 {
                return nil
            }
        }
        return (height, weight)
    }
    
    func calculateDisplayBMI() {
        guard let (height, weight) = validateInput() else {
            BMIResultLabel.text = "Invalid input (check limits also)"
            CategoryLabel.text = ""
            return
        }
        
        var bmi: Double = 0.0
        
        if unitSegmentedControl.selectedSegmentIndex == 0 {
            let heightInMeters = height / 100
            bmi = weight / (heightInMeters * heightInMeters)
        } else {
            let heightInMeters = height * 0.0254
            let weightInKg = weight * 0.45359
            bmi = weightInKg / (heightInMeters * heightInMeters)
        }
        
        BMIResultLabel.text = String(format: " %.2f", bmi)
        CategoryLabel.text = getBMICategory(bmi)
    }
    
    func getBMICategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
