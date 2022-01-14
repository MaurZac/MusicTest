//
//  ViewController.swift
//  MusicTest
//
//  Created by MaurZac on 07/01/22.
//

import UIKit
import AVFoundation

extension UIImageView {

    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var heroes = [] as [Hero]
    @IBOutlet weak var audioplayer: UIView!
    var audioplayr = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        audioplayer.layer.cornerRadius = 50
        setupView()
        apiCall()
        audioplayS()

    }
    
    func audioplayS(){
        let sound  = Bundle.main.path(forResource: "song3", ofType: "mp3")
        do {
            audioplayr = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        audioplayr.play()
    }
    @IBAction func stopBtn(_ sender: UIButton) {
        audioplayr.stop()
    }
    
    
    
    func apiCall(){
        let url  = URL(string: "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                do{
                    self.heroes = try JSONDecoder().decode([Hero].self, from: data!)

                }catch{
                    print("Parse Error")
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }

    
 
    
    func setupView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }


}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        let defaultLink = "https://api.opendota.com"
        let completeLInk = defaultLink + heroes[indexPath.row].img
        cell.imageView.downloaded(from: completeLInk)
        cell.nameLabel.text = heroes[indexPath.row].localized_name.capitalized
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = cell.imageView.frame.height / 2
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc  = storyboard?.instantiateViewController(withIdentifier: "PopViewController") as? PopViewController
        vc?.name = heroes[indexPath.row].localized_name.capitalized
        let defaultLink = "https://api.opendota.com"
        let completeLInk = defaultLink + heroes[indexPath.row].img
        vc?.url = completeLInk
        
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width/5 - 1

        if UIDevice.current.orientation.isLandscape {
            var _: CGFloat = collectionView.accessibilityFrame.width/6 - 1
        }
        return CGSize(width: width, height: width)
    }
    
    
    
    
}

