//
//  ColorPickerViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 01.03.2024.
//

import UIKit
import FlexColorPicker

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var hexView: UIView!
    @IBOutlet weak var pizdaImageView: UIImageView!
    @IBOutlet weak var stackColours: UIStackView!
    @IBOutlet weak var colorPaletterView: RadialPaletteControl!
    @IBOutlet weak var brightness: UILabel!
    @IBOutlet weak var saturationLabel: UILabel!
    @IBOutlet weak var brightnessSlider: BrightnessSliderControl!
    @IBOutlet weak var saturationSlider: SaturationSliderControl!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var lightSamartLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensityView: UIView!
    @IBOutlet weak var plinthLabel: UILabel!
    @IBOutlet weak var plinthView: UIView!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var offButton: UIButton!
    
    var lampModel: LampModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.setTitle("save".localized, for: .normal)
        lightSamartLabel.text = lampModel.name
        plinthLabel.text = "plinth".localized + " E27"
        intensityLabel.text = "intensity".localized
        brightness.text = "brightness".localized
        saturationLabel.text = "saturation".localized
        colorPaletterView.addTarget(self, action: #selector(colorPicked(by:)), for: .valueChanged)
        brightnessSlider.addTarget(self, action: #selector(colorPicked(by:)), for: .valueChanged)
        brightnessSlider.reversePercentage = true
        saturationSlider.addTarget(self, action: #selector(colorPicked(by:)), for: .valueChanged)
        let color = UIColor(hex: lampModel.color)
        colorPaletterView.selectedColor = color
        brightnessSlider.selectedColor = color
        saturationSlider.selectedColor = color
        pizdaImageView.tintColor = color
        hexLabel.text = "HEX: #" + colorPaletterView.selectedColor.hexValue()
        roomLabel.text = lampModel.room
        hidesBottomBarWhenPushed = true
        
        saveButton.layer.cornerRadius = 30
        saveButton.layer.masksToBounds = true
        hexView.layer.cornerRadius = 10
        hexView.layer.masksToBounds = true
        
        stackColours.arrangedSubviews.forEach({ item in
            item.layer.cornerRadius = 17
            item.layer.masksToBounds = true
        })
        
        stackColours.arrangedSubviews[1].layer.borderWidth = 1
        stackColours.arrangedSubviews[1].layer.borderColor = UIColor(red: 136/255, green: 166/255, blue: 248/255, alpha: 1).cgColor
        stackColours.arrangedSubviews[2].layer.borderWidth = 1
        stackColours.arrangedSubviews[2].layer.borderColor = UIColor(red: 165/255, green: 251/255, blue: 254/255, alpha: 1).cgColor
        stackColours.arrangedSubviews[3].layer.borderWidth = 1
        stackColours.arrangedSubviews[3].layer.borderColor = UIColor(red: 177/255, green: 253/255, blue: 153/255, alpha: 1).cgColor
        stackColours.arrangedSubviews[4].layer.borderWidth = 1
        stackColours.arrangedSubviews[4].layer.borderColor = UIColor(red: 191/255, green: 115/255, blue: 87/255, alpha: 1).cgColor
        stackColours.arrangedSubviews[5].layer.borderWidth = 1
        stackColours.arrangedSubviews[5].layer.borderColor = UIColor(red: 228/255, green: 101/255, blue: 98/255, alpha: 1).cgColor
        stackColours.arrangedSubviews[6].layer.borderWidth = 1
        stackColours.arrangedSubviews[6].layer.borderColor = UIColor(red: 195/255, green: 101/255, blue: 128/255, alpha: 1).cgColor
        stackColours.arrangedSubviews[7].layer.borderWidth = 1
        stackColours.arrangedSubviews[7].layer.borderColor = UIColor(red: 159/255, green: 89/255, blue: 214/255, alpha: 1).cgColor
        
        [hexView, plinthView, intensityView].forEach( { item in
            item?.layer.cornerRadius =  10
            item?.layer.masksToBounds = true
        })
    }
    
    @objc
    open func colorPicked(by control: Any?) {
        guard let control = control as? ColorControl else {
            return
        }
        if control === brightnessSlider,
           let posis = control as? BrightnessSliderControl {
            let value = posis.sliderDelegate.valueAndGradient(for: posis.selectedHSBColor).value
            let stringValue = Int(round((posis.reversePercentage ? 1 - value : value) * 100))
            intensityLabel.text = "intensity".localized + " " + stringValue.description + "%"
            let baseColor = colorPaletterView.selectedHSBColor
            colorPaletterView.setSelectedHSBColor(baseColor.withBrightness(posis.selectedHSBColor.brightness), isInteractive: true)
            hexLabel.text = "HEX: #" + colorPaletterView.selectedColor.hexValue()
            pizdaImageView.tintColor = colorPaletterView.selectedColor
        } else if let posis = control as? SaturationSliderControl   {
            let baseColor = colorPaletterView.selectedHSBColor
            colorPaletterView.setSelectedHSBColor(baseColor.withSaturation(posis.selectedHSBColor.saturation), isInteractive: true)
            hexLabel.text = "HEX: #" + colorPaletterView.selectedColor.hexValue()
            pizdaImageView.tintColor = colorPaletterView.selectedColor
        } else if let huesos = control as? ColorPaletteControl {
            hexLabel.text = "HEX: #" + huesos.selectedColor.hexValue()
            pizdaImageView.tintColor = colorPaletterView.selectedColor
        }
    }
    
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        guard let intColor = Int(colorPaletterView.selectedColor.hexValue(), radix: 16) else { return }
        lampModel.color = intColor
        DatabaseManager.shared.update(lampModel)
        ActionManager.shared.reload()
        dismiss(animated: true)
    }
    
    @IBAction func offBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func menuBtnDidTap(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "editName".localized, style: .default, handler: editName))
        alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: deleteCell))
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    func deleteCell(action: UIAlertAction) {
       
    }
    
    func editName(_ action: Any) {
        
    }
}

extension ColorPickerViewController: ColorPickerDelegate {
}

func hexStringFromColor(color: UIColor) -> String {
    let components = color.cgColor.components
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0

    let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    print(hexString)
    return hexString
 }
