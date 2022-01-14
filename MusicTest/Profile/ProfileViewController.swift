//
//  ProfileViewController.swift
//  MusicTest
//
//  Created by MaurZac on 13/01/22.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var photoProfile: UIImageView!
    
    @IBOutlet weak var descripcion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        photoProfile.layer.cornerRadius = photoProfile.frame.height / 2
        photoProfile.contentMode = .scaleAspectFill
        descripcion.numberOfLines = 10
        // Do any additional setup after loading the view.
    }
    


}
