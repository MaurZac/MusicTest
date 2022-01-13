//
//  PopViewController.swift
//  MusicTest
//
//  Created by MaurZac on 13/01/22.
//

import UIKit

class PopViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var imgHero: UIImageView!
    
    var name  = ""
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameHero.text = name
        print(url)
        imgHero.downloaded(from: url)
        containerView.layer.cornerRadius =  50
        // Do any additional setup after loading the view.
    }



}
