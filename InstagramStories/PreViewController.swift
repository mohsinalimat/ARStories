//
//  PreViewController.swift
//  InstagramStories
//
//  Created by mac05 on 05/10/17.
//

import UIKit
import AVFoundation
import AVKit

class PreViewController: UIViewController, SegmentedProgressBarDelegate {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var pageIndex : Int = 0
    var items = [[String: Any]]()
    var item = [[String : String]]()
    
    fileprivate var SPB: SegmentedProgressBar!
    
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        item = self.items[pageIndex]["items"] as! [[String : String]]
        
        SPB = SegmentedProgressBar(numberOfSegments: self.item.count, duration: 5)
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 4)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 4)
        }
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 2
        view.addSubview(SPB)
        view.bringSubview(toFront: SPB)
        
        print(item)
        self.SPB.startAnimation()
        playVideoOrLoadImage(index: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - SegmentedProgressBarDelegate
    //1
    func segmentedProgressBarChangedIndex(index: Int) {
        print("Now showing index: \(index)")
        playVideoOrLoadImage(index: index)
    }
    
    //2
    func segmentedProgressBarFinished() {
        print("Now showing index: \(pageIndex)")
        if pageIndex == (self.items.count - 1) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            _ = ContentViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
        
        if item[index]["content"] == "image" {
            self.SPB.duration = 5
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
            self.imagePreview.image = UIImage(named: item[index]["item"]!)
        }
        else {
            let moviePath = Bundle.main.path(forResource: item[index]["item"], ofType: "mp4")
            if let path = moviePath {
                self.imagePreview.isHidden = true
                self.videoView.isHidden = false
                
                let url = NSURL.fileURL(withPath: path)
                self.player = AVPlayer(url: url)
                
                let videoLayer = AVPlayerLayer(player: self.player)
                videoLayer.frame = view.bounds
                videoLayer.videoGravity = .resizeAspectFill
                self.videoView.layer.addSublayer(videoLayer)
                
                let asset = AVAsset(url: url)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                print(durationTime)
                
                self.SPB.duration = durationTime
                self.player.play()
            }
        }
    }
    
    //MARK: - Button actions
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}