//
//  TileProperties.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/18/21.
//

import SwiftUI

struct TileProperties {
    
    let value: Int
    let theme: String
    
    var valueToColor: [String: [UIColor]] = ["blue": [#colorLiteral(red: 0.8, green: 0.7568627451, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.8705882353, green: 0.9294117647, blue: 0.9411764706, alpha: 1), #colorLiteral(red: 0.7098039216, green: 0.9176470588, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 0.5607843137, green: 0.8117647059, blue: 0.8196078431, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.768627451, blue: 0.8156862745, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.768627451, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.2235294118, green: 0.6352941176, blue: 0.8588235294, alpha: 1), #colorLiteral(red: 0.3137254902, green: 0.537254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.07058823529, green: 0.3647058824, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.1019607843, green: 0.3137254902, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.01176470588, green: 0.3254901961, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0, green: 0.137254902, blue: 0.4, alpha: 1)],
                                             "red": [#colorLiteral(red: 0.8, green: 0.7568627451, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 1, green: 0.8761147857, blue: 0.9028004408, alpha: 1), #colorLiteral(red: 0.9457356334, green: 0.7945415378, blue: 0.792933166, alpha: 1), #colorLiteral(red: 0.9587334991, green: 0.7117092609, blue: 0.7167955041, alpha: 1), #colorLiteral(red: 0.9827156663, green: 0.6315714121, blue: 0.6308462024, alpha: 1), #colorLiteral(red: 0.9647058824, green: 0.5490196078, blue: 0.5490196078, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.3843137255, blue: 0.3882352941, alpha: 1), #colorLiteral(red: 0.8591150641, green: 0.366625607, blue: 0.3687277436, alpha: 1), #colorLiteral(red: 0.7982564569, green: 0.229629457, blue: 0.2302599549, alpha: 1), #colorLiteral(red: 0.7378394604, green: 0.1275630891, blue: 0.1099281088, alpha: 1), #colorLiteral(red: 0.6761279702, green: 0.002816373482, blue: 0, alpha: 1), #colorLiteral(red: 0.5270999074, green: 0.01789107174, blue: 0.002629485214, alpha: 1)],
                                             "classic": [#colorLiteral(red: 0.7993987203, green: 0.7560519576, blue: 0.7040259242, alpha: 1), #colorLiteral(red: 0.9319877028, green: 0.8933374882, blue: 0.8544344306, alpha: 1), #colorLiteral(red: 0.9342114925, green: 0.8816730976, blue: 0.7900771499, alpha: 1), #colorLiteral(red: 0.9513941407, green: 0.6978855729, blue: 0.47649616, alpha: 1), #colorLiteral(red: 0.9658213258, green: 0.584209621, blue: 0.3910084963, alpha: 1), #colorLiteral(red: 0.9669234157, green: 0.4852967858, blue: 0.3742964864, alpha: 1), #colorLiteral(red: 0.9668807387, green: 0.3700083196, blue: 0.2341985106, alpha: 1), #colorLiteral(red: 0.9277891517, green: 0.8149618506, blue: 0.4505269527, alpha: 1), #colorLiteral(red: 0.9306313396, green: 0.7987708449, blue: 0.3824666142, alpha: 1), #colorLiteral(red: 0.9287785888, green: 0.7826912999, blue: 0.3156784177, alpha: 1), #colorLiteral(red: 0.9301154613, green: 0.7746508718, blue: 0.245347321, alpha: 1), #colorLiteral(red: 0.9275302887, green: 0.7625816464, blue: 0.1786460578, alpha: 1)]]
    
    init(of value: Int, withTheme theme: String) {
        self.value = value
        self.theme = theme
    }
    
    func getColor() -> UIColor {
        return valueToColor[theme]![value]
    }
    
    func getLabel(withSize size: CGFloat, tile: UIView) -> UILabel {
        var number = ""
        if value != 0 {
            number = String(Int(pow(2.0, Double(value))))
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
        label.textColor = #colorLiteral(red: 0.4644427896, green: 0.4306486547, blue: 0.3960360289, alpha: 1)
        label.font = UIFont(name: "Arial Bold", size: CGFloat(36.0 - Double(self.value) * 1.3))
        label.text = number
        label.textAlignment = .center
        return label
    }
    
}
