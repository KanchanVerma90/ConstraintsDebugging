//
//  ConstraintsVC.swift
//  GameOfConstraints
//
//  Created by Kanchan Verma on 29/04/2021.
//

import UIKit

protocol updateViews {
    func constraintChanged(newConstraingt: NSLayoutConstraint)
}

enum pickerFor {
    case relation
    case attributes
    case subviews
    case priority
}

enum errorType {
    case prior
    case multiplier
}
class ConstraintsVC: UIViewController , UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var relationField: UITextField!
    @IBOutlet weak var pickerVW: UIPickerView!
    @IBOutlet weak var toggleIsActive: UISwitch!
    @IBOutlet weak var FirstObj: UITextField!
    var theConstraint: NSLayoutConstraint!
    @IBOutlet weak var priority: UITextField!
    @IBOutlet weak var offSet: UITextField!
    @IBOutlet weak var multiplier: UITextField!
    @IBOutlet weak var SecObj: UITextField!
    var selectedField: pickerFor = .relation
    let relationArr = ["=",">=","=<"]
    var updateInitialVW: updateViews?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        FirstObj.isUserInteractionEnabled = false
        SecObj.isUserInteractionEnabled = false
        FirstObj.text = "\((theConstraint.firstItem as? UIView)?.accessibilityIdentifier ?? theConstraint.firstItem?.identifier ?? "").\(theConstraint.firstAttribute.readableAttr())"
        SecObj.text = "\((theConstraint.secondItem as? UIView)?.accessibilityIdentifier ?? theConstraint.secondItem?.identifier ?? "").\(theConstraint.secondAttribute.readableAttr())"
        if theConstraint.secondAttribute.rawValue == 0 {
            SecObj.text = ""
        }
        priority.text = "\(theConstraint.priority.rawValue)"
        offSet.text = "\(theConstraint.constant)"
        multiplier.text = SecObj.text?.isEmpty ?? true ? "" : "\(theConstraint.multiplier)"
        toggleIsActive.isOn = theConstraint.isActive
        relationField.text = theConstraint.relation.equalityStr()
        relationField.isUserInteractionEnabled = true
    }
   
    @IBAction func isActiveToggle(_ sender: Any) {
        theConstraint.isActive = !theConstraint.isActive
    }
    
    @IBAction func updateFirstScreen(_ sender: Any) {
        if !validatepriority() {
            showError(forCase: .prior)
            return
        }
        theConstraint.priority = UILayoutPriority.init((priority.text as NSString?)?.floatValue ?? 0.0)
        theConstraint.constant = CGFloat((offSet.text as NSString?)?.floatValue ?? 0.0)
        theConstraint.isActive = toggleIsActive.isOn
        //theConstraint.multiplier = CGFloat((multiplier.text as NSString?)?.floatValue ?? 0.0)
        updateInitialVW?.constraintChanged(newConstraingt: theConstraint)
        self.navigationController?.popToRootViewController(animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 11:
            selectedField = .relation
            pickerVW.isHidden = false
        default:
            selectedField = .relation
        }
        
    }
    func validatepriority() -> Bool {
        return (((priority.text as NSString?)?.floatValue ?? 0.0) > 0) && (((priority.text as NSString?)?.floatValue ?? 0.0) < 1001)
    }
    func validateMultiplier() -> Bool {
        return theConstraint.multiplier == CGFloat((multiplier.text as NSString?)?.floatValue ?? 0.0)
    }
    func showError(forCase: errorType) {
        var msg = ""
        switch forCase {
        case .prior:
            msg = "Priorities must be greater than 0 and less or equal to NSLayoutPriorityRequired, which is 1000.000000."
        case .multiplier:
            msg = "Multiplier is a get only property. Which means it can not be changed dynamically as it lacks set functionality of a property."
        }
        let alert = UIAlertController.init(title: "Warning", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedField {
        case .relation:
            return 3
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedField {
        case .relation:
            return relationArr[row]
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected row \(relationArr[row])")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 13 {
            showError(forCase: .multiplier)
            return
        }
    }
    
}
