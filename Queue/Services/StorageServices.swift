//
//  StorageServices.swift
//  Queue
//
//  Created by Aditya Gunda on 8/25/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import Firebase
import Alamofire
import AlamofireImage

let storage = Storage.storage()
let storageRef = storage.reference()

class StorageService {
    
    static let instance = StorageService()
    private var _REF_PROFILE_PICS = storageRef.child("profilePictures")
    
    func storeProfilePic(link: String, userid: String){
        let profilePicRef = _REF_PROFILE_PICS.child("\(userid).png")
        let picURL = URL(string: link)
        Alamofire.request(picURL!).responseImage { response in
            switch response.result {
            case .success(let image):
                let uploadPic = UIImagePNGRepresentation(image)
                profilePicRef.putData(uploadPic!)
                DataService.instance.writeUserData(uid: userid, key: profilePicKey, data: true)
            case .failure(let error):
                print("error uploading image") // do better error handling
            }
           
        }
    }
}
