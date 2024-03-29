//
//  MusicIphoneViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 04.03.2024.
//

import UIKit
import Combine
import BottomSheet
import AVFoundation

class MusicIphoneViewController: UIViewController {

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playBackLightBtn: UIButton!
    @IBOutlet weak var musicOnIPhoneLabel: UILabel!
    @IBOutlet weak var selectLightButton: UIButton!
    
    var lamps = [LampModel]()
    
    @Published var isPlayiing: Bool = false
    
    var audioRecorder: AVAudioRecorder?
    
    var cancellable = Set<AnyCancellable>()
    
    var meteringTimer: Timer?
    // record value every 0.08 seconds.
    var meteringFrequency = 0.08
   
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackLightBtn.setTitle("playbackLight".localized, for: .normal)
        musicOnIPhoneLabel.text = "musicOnIphone2".localized
        selectLightButton.setTitle("selectLight".localized, for: .normal)
        selectLightButton.layer.cornerRadius = 30
        selectLightButton.layer.masksToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MusicCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MusicCollectionCell")
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 0, right: 16)
        startRecording()
        stopRecording()
        startRecording()
        bind()
    }
    
    func bind() {
        $isPlayiing.sink(receiveValue: { [unowned self] isPlaying in
            playPauseButton.isSelected = isPlaying
        }).store(in: &cancellable)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch let error as NSError {
            print(error)
        }
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.videoRecording, options: AVAudioSession.CategoryOptions.mixWithOthers)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
        self.audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
        
        self.audioRecorder?.prepareToRecord()
        self.audioRecorder?.isMeteringEnabled = true
        self.audioRecorder?.record()
        
        self.runMeteringTimer()
    }
    
    private func stopRecording() {
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        
        self.stopMeteringTimer()
    }
    
    @IBAction func selectLightDidTap(_ sender: Any) {
        selectLight()
    }
    
    func selectLight() {
        let storyboard = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MusicAddLightViewController") as! MusicAddLightViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.saveDidTap = { [unowned self] selectedLamps in
            lamps = selectedLamps
            collectionView.reloadData()
        }
        present(vc, animated: true)
    }
    
    @IBAction func playPauseDidTap(_ sender: Any) {
        guard !lamps.isEmpty else {
            selectLight()
            return
        }
        isPlayiing.toggle()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
   
    @IBAction func playBackLightBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "PlaybackLightView", bundle: nil).instantiateViewController(identifier: "PlaybackLightViewController")
        let navigationContorller = BottomSheetNavigationController(rootViewController: entrance, configuration: BottomSheetConfiguration(
            cornerRadius: 40,
            pullBarConfiguration: .hidden,
            shadowConfiguration: .init(backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.46), blur: .regular)
        ))
        navigationContorller.navigationBar.isHidden = true
        navigationContorller.view.backgroundColor = UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1)
        presentBottomSheet(viewController: navigationContorller, configuration: BottomSheetConfiguration(
            cornerRadius: 40,
            pullBarConfiguration: .hidden,
            shadowConfiguration: .init(backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.46), blur: .regular)
        ))
    }
}

extension MusicIphoneViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 227, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCollectionCell", for: indexPath)
        let lamp = lamps[indexPath.row]
        (cell as? MusicCollectionCell)?.configure(roomNameLabel: lamp.room ?? "", deviceNameLabel: lamp.name, isEnabled: lamp.isEnabled)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lamp = lamps[indexPath.row]
        lamp.isEnabled.toggle()
        DatabaseManager.shared.update(lamp)
        lamp.accessory?.getCharacteristic(forType: .power)?.writeValue(lamp.isEnabled, completionHandler: { error in
            print("error \(error)")
        })
        ActionManager.shared.reload()
        collectionView.reloadItems(at: [indexPath])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lamps.count
    }
}

extension MusicIphoneViewController {
    fileprivate func runMeteringTimer() {
        
        self.meteringTimer = Timer.scheduledTimer(withTimeInterval: self.meteringFrequency, repeats: true, block: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            
            // 1.1 to increase the feedback for low voice - due to noise cancellation.
            let amplitude = 2.3 * pow(10.0, averagePower / 20.0)
            print(amplitude)
            let clampedAmplitude = min(max(amplitude, 0), 1)
            lamps.forEach({ light in
                guard self.isPlayiing else { return }
                let color = self.adjustRedColorShade(for: CGFloat(clampedAmplitude), baseColor: UIColor(hex: light.color)).hsbColor
                light.accessory!.getCharacteristic(forType: .hue)!.writeValue(color.hue * 360, completionHandler: { error in
                    print(error)
                })
//                light.accessory!.getCharacteristic(forType: .saturation)!.writeValue(color.saturation * 100, completionHandler: { error in
//                    print(error)
//                })
                light.accessory!.getCharacteristic(forType: .brightness)!.writeValue(color.brightness * 100, completionHandler: { error in
                    print(error)
                })
            })
        })
        
        self.meteringTimer?.fire()
    }
    
    func adjustRedColorShade(for parameter: CGFloat, baseColor: UIColor) -> UIColor {
        
        // Извлечение компонентов цвета
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        baseColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Изменяем насыщенность и яркость, оставляя оттенок неизменным
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness * parameter, alpha: alpha)
        print("[test] result color \(newColor.hexValue())")
        return newColor
    }
    
    fileprivate func stopMeteringTimer() {
        
        self.meteringTimer?.invalidate()
        self.meteringTimer = nil
    }
}

protocol AudioMeteringDelegate: NSObjectProtocol {
    
    func audioMeter(didUpdateAmplitude amplitude: Float)
}
