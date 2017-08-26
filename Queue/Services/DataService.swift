import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_MUSIC_SERVICE_PLAYLISTS = DB_BASE.child("musicServicePlaylists")

    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
  
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child("\(uid)").updateChildValues(userData)
    }
    
    func writeUserData(uid: String, key: String, data: Any){
        REF_USERS.child("\(uid)").updateChildValues([key:data])
    }
    
    func readUserData(uid: String, key: String, completion: @escaping (_ response: Any?, _ error: Bool) -> Void){
        self.REF_USERS.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Any {
                completion(value, false)
            } else {
                completion(nil, true)
            }
        })
    }

}
