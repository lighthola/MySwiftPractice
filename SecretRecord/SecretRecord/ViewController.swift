//
//  ViewController.swift
//  SecretRecord
//
//  Created by Bevis Chen on 2017/11/30.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit
import AVFoundation

struct AudioFileManager {
    static var audiosDirectory: URL {
        let audiosDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Recorder", isDirectory: true)
        if !FileManager.default.fileExists(atPath: audiosDirectory.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: audiosDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        return audiosDirectory
    }
    
    static var audioFiles: [URL] {
        var audioFiles: [URL] = []
        do {
            let audiosDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Recorder", isDirectory: true)
            
            let audioFileURLs = try FileManager.default.contentsOfDirectory(at: audiosDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            audioFiles = audioFileURLs
        } catch  {
            print(error)
        }
        return audioFiles
    }
}

class AudioRecorder: AVAudioRecorder {
    override init() {
        let audioURL: URL = {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            format.timeZone = TimeZone(abbreviation: "GMT+8")
            let fileName = format.string(from: Date())
            let audiosDirectory = AudioFileManager.audiosDirectory
            let audioURL = audiosDirectory.appendingPathComponent(fileName + ".caf", isDirectory: false)
            return audioURL
        }()
        
        let settings = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVSampleRateKey: NSNumber(value: 8000),
            AVNumberOfChannelsKey: NSNumber(value: 1),
            AVLinearPCMBitDepthKey: NSNumber(value: 16),
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)
        ]
        
        do {
            try super.init(url: audioURL, settings: settings)
        } catch {
            print(error)
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var audioRecorder: AudioRecorder?
    var audioPlayer: AVAudioPlayer?
    //let recorderSetting = [AVFormatIDKey: ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            if allowed {
                print("同意錄音")
            } else {
                print("不同意錄音")
            }
        }
        
    }

    @IBAction func recordBtnPressed(_ sender: UIButton) {
        if let audioRecorder = audioRecorder {
            if audioRecorder.isRecording {
                audioRecorder.stop()
                self.audioRecorder = AudioRecorder()
                sender.setTitle("錄音", for: .normal)
                tableView.reloadData()
            } else {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try AVAudioSession.sharedInstance().setActive(true)
                    audioRecorder.prepareToRecord()
                    let success = audioRecorder.record()
                    sender.setTitle("停止錄音", for: .normal)
                    if success {
                        print("開始錄音成功")
                    } else {
                        print("開始錄音失敗")
                    }
                } catch {
                    print(error)
                }
                
            }
        } else {
            audioRecorder = AudioRecorder()
            recordBtnPressed(sender)
        }
    }
    
    @IBAction func audioPlayBtnPressed(_ sender: Any) {
        
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AudioFileManager.audioFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = AudioFileManager.audioFiles[indexPath.row].lastPathComponent
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let audio = AudioFileManager.audioFiles[indexPath.row]
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audio)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            audioPlayer?.play()
        } catch {
            print(error)
        }
        
        
    }
}

