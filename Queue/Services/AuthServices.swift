import Foundation
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    
    var current_uid: String {
            return Auth.auth().currentUser!.uid
    }
    
    func registerUser(withEmail email: String, andPassword password: String, firstName: String, lastName: String, userCreationComplete: @escaping
        (_ status: Bool, _ error: Error?)-> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                userCreationComplete(false,error)
                return
            }
            let userdata = ["provider": user?.providerID, userEmailKey: user?.email, userFirstNameKey: firstName, userLastNameKey: lastName]
            let userid = user!.uid
            DataService.instance.createDBUser(uid: userid, userData: userdata)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping
        (_ status: Bool, _ error: Error?)-> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false,error)
                return
            }
            loginComplete(true,nil)
        }
    }
    
    func facebookAuth(withCredential credential: AuthCredential, userAuthComplete: @escaping (_ status: Bool, _ error: Error?, _ errorSource: String?) ->()){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                userAuthComplete(false, error, "firebase")
                return
            }
            
            let connection = GraphRequestConnection()
            let params1 = ["fields": "id, name, email, picture"]
            connection.add(GraphRequest(graphPath: "/me", parameters: params1)) { httpResponse, result in
                switch result {
                case .success(let response): //Graph Result success case
                    let username = response.dictionaryValue?["name"] as? String
                    let splitName = username!.components(separatedBy: " ")
                    let userData = ["provider": "Facebook", userFirstNameKey: splitName[0], userLastNameKey: splitName[1], "facebook_accesstoken": FBSDKAccessToken.current().tokenString, facebookIDKey: response.dictionaryValue?["id"]]
                    let userid = user!.uid
                    let picture = response.dictionaryValue?["picture"]
                    let picture_json = JSON(picture)
                    DataService.instance.createDBUser(uid: userid, userData: userData)
                    if picture_json["data"]["is_silhouette"].int == 0 {
                        let picture_url = picture_json["data"]["url"].string
                        //upload picture
                        StorageService.instance.storeProfilePic(link: picture_url!, userid: AuthService.instance.current_uid)
                    }
                    userAuthComplete(true, nil, nil)
                case .failed(let error): //Graph Result failed case
                    userAuthComplete(false, error, "graph_api")
                }
            }
            connection.start()
        }
        
        let params = ["fields": "id,name"]
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error == nil {
                let json = JSON(result!)
                let friendlist = json["data"].array
                if friendlist?.count != 0 {
                    DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: fbFriendsListKey, data: friendlist!)
                }
            } else {
                print("Error Getting Friends \(String(describing: error))");
            }
        })
        connection.start()
        
    }
    
    func facebookLogin(withCredential credential: AuthCredential, userLoginComplete: @escaping (_ status: Bool, _ error: Error?) ->()){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                userLoginComplete(false,error)
                return
            }
            userLoginComplete(true,nil)
        }
    }
}
