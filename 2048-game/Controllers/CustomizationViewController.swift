//
//  CustomizationViewController.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/19/21.
//

import UIKit

protocol CustomizationDelegate {
    func didCustomize(boardDimension: Int, theme: String)
}

class CustomizationViewController: UIViewController {
    
    @IBOutlet weak var blueThemeButton: UIButton!
    @IBOutlet weak var redThemeButton: UIButton!
    @IBOutlet weak var classicThemeButton: UIButton!
    
    @IBOutlet weak var stepperValueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var delegate: CustomizationDelegate?
    
    var boardDimensions: Int = 4
    var theme: String = "classic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepper.value = 4
        stepperValueLabel.text = Int(stepper.value).description
        
        classicThemeButton.backgroundColor = #colorLiteral(red: 0.5767070055, green: 0.4757245183, blue: 0.3842762709, alpha: 1)
        
        classicThemeButton.layer.cornerRadius = classicThemeButton.frame.height / 7
        redThemeButton.layer.cornerRadius = redThemeButton.frame.height / 7
        blueThemeButton.layer.cornerRadius = blueThemeButton.frame.height / 7
    }
    
    func clearHighlight() {
        classicThemeButton.backgroundColor = .clear
        redThemeButton.backgroundColor = .clear
        blueThemeButton.backgroundColor = .clear
    }

}

// MARK: - Handling Buttons Pressed

extension CustomizationViewController {
    @IBAction func steppedPressed(_ sender: UIStepper) {
        stepperValueLabel.text = Int(sender.value).description
        boardDimensions = Int(sender.value)
    }
    
    @IBAction func blueThemeButtonPressed(_ sender: UIButton) {
        clearHighlight()
        blueThemeButton.backgroundColor = #colorLiteral(red: 0.5767070055, green: 0.4757245183, blue: 0.3842762709, alpha: 1)
        theme = "blue"
    }
    
    @IBAction func redThemeButtonPressed(_ sender: UIButton) {
        clearHighlight()
        redThemeButton.backgroundColor = #colorLiteral(red: 0.5767070055, green: 0.4757245183, blue: 0.3842762709, alpha: 1)
        theme = "red"
    }
    
    @IBAction func classicThemeButtonPressed(_ sender: UIButton) {
        clearHighlight()
        classicThemeButton.backgroundColor = #colorLiteral(red: 0.5767070055, green: 0.4757245183, blue: 0.3842762709, alpha: 1)
        theme = "classic"
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        self.delegate?.didCustomize(boardDimension: self.boardDimensions, theme: self.theme)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
