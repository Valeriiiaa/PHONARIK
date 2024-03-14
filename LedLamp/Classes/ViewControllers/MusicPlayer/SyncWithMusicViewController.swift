//
//  SyncWithMusicViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 05.03.2024.
//

import UIKit
import BottomSheet
import AVFAudio
import Combine

class SyncWithMusicViewController: UIViewController {
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playbackLightBtn: UIButton!
    @IBOutlet weak var syncWithMusicLabel: UILabel!
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
        playbackLightBtn.setTitle("playbackLight".localized, for: .normal)
        syncWithMusicLabel.text = "syncWithMusic2".localized
        selectLightButton.setTitle("selectLight".localized, for: .normal)
        selectLightButton.layer.cornerRadius = 30
        selectLightButton.layer.masksToBounds = true
        collectionView.register(UINib(nibName: "MusicCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MusicCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 0, right: 16)
        startRecording()
        stopRecording()
        bind()
    }
    
    func bind() {
        $isPlayiing.sink(receiveValue: { [unowned self] isPlaying in
            playPauseButton.isSelected = isPlaying
            if isPlaying {
                startRecording()
            } else {
                stopRecording()
            }
        }).store(in: &cancellable)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

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
    
    @IBAction func playPauseDidTap(_ sender: Any) {
        guard !lamps.isEmpty else {
            selectLight()
            return
        }
        isPlayiing.toggle()
    }
    
    @IBAction func playbackLightBtnDidTap(_ sender: Any) {
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
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func selectLightBtnDidTap(_ sender: Any) {
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
}

extension SyncWithMusicViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 227, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCollectionCell", for: indexPath)
        let lamp = lamps[indexPath.row]
        (cell as? MusicCollectionCell)?.configure(roomNameLabel: lamp.room ?? "", deviceNameLabel: lamp.name, isEnabled: lamp.isEnabled)
        return cell
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

extension SyncWithMusicViewController {
    
    fileprivate func runMeteringTimer() {
        
        self.meteringTimer = Timer.scheduledTimer(withTimeInterval: self.meteringFrequency, repeats: true, block: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            
            // 1.1 to increase the feedback for low voice - due to noise cancellation.
            let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
            let clampedAmplitude = min(max(amplitude, 0), 1)
            lamps.forEach({ light in
                light.accessory?.getCharacteristic(forType: .hue)?.writeValue(clampedAmplitude * 360, completionHandler: { error in
                    print(error)
                })
            })
        })
        
        self.meteringTimer?.fire()
    }
    
    fileprivate func stopMeteringTimer() {
        
        self.meteringTimer?.invalidate()
        self.meteringTimer = nil
    }
}
