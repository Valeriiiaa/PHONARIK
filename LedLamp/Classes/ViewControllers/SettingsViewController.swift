//
//  ViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import UIKit

class SettingsViewController: UIViewController {
   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let items = SettingsModel.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsLabel.text = "settings".localized
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            let url = URL(string: "https://docs.google.com/document/d/1-zWJG6PrjMv8GXakefrHsDzbURqBy4KNNp_vdRZSew0")!
            UIApplication.shared.open(url)
        } else if indexPath.row == 2 {
            let url = URL(string: "https://docs.google.com/document/d/1-zWJG6PrjMv8GXakefrHsDzbURqBy4KNNp_vdRZSew0")!
            UIApplication.shared.open(url)
        } else if indexPath.row == 3 {
            
        } else if indexPath.row == 4 {
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        } else if indexPath.row == 5 {
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else if indexPath.row == 6 {
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let item = items[indexPath.row]
        (cell as? SettingsCell)?.configure(settingsLabel: item.title, settingsImage: item.image)
        return cell
    }
}
