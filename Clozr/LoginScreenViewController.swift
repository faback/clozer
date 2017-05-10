//
//  LoginScreenViewController.swift
//  Clozr
//
//  Created by Fateh Singh on 4/27/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth


class LoginScreenViewController: UIViewController {

    @IBOutlet weak var loginBackGroundImage: UIImageView!
    
    
    var currentFacebookUser : User!
    fileprivate var retryCounter  = 0
    fileprivate let maxRetries = 3
    var currentFirUser:FIRUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 8, delay: 0,  options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.loginBackGroundImage.transform=CGAffineTransform(scaleX: 2, y: 2);
        }) { (completed) in
        //            self.loginBackGroundImage.transform = CGAffineTransform.identity
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email","user_friends"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.getCurrentUserInfo(completionHandler: { (result, error) in
                    print("try")
                })
                
                
            })
            
        }
    }
    
    
    func getCurrentUserInfo(completionHandler:((Any?, Error?) -> ())? = nil) {
        
        if currentFacebookUser == nil {
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,about,birthday,email,first_name,last_name,name,gender,location,relationship_status,picture.width(800).height(600)"])
            
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                if error != nil {
                    self.showErrorMessage(error: error!, completionHandler:{ retry in
                        if retry == true {
                            self.getCurrentUserInfo()
                        }
                    })
                }
                else {
                    if let data:[String:AnyObject] = result as? [String : AnyObject] {
                       let user = User(dictionary: data)
                        if let fbuser = user {
                            self.currentFacebookUser = fbuser
                            let user = FIRAuth.auth()?.currentUser
                            self.currentFirUser = user
                            if ((user) != nil) {
                                User.createMe(userUid: user!, user: self.currentFacebookUser)
                            }
//                            self.getUsersFriends()
                            User.createMe(userUid: self.currentFirUser!, user: self.currentFacebookUser)
                            User.me = self.currentFacebookUser
                            FBClient.currentFacebookUser = self.currentFacebookUser
                            
                            self.performSegue(withIdentifier: "postLogin", sender: self)

                        }
                        else {
                            self.showAbortMessage(title: Strings.errorAbortTitle,message: Strings.errorUserDataMissingMessage)
                        }
                    }
                    else {
                        self.showAbortMessage(title: Strings.errorAbortTitle,message: Strings.errorAbortMessage)
                    }
                    
                }
                
                completionHandler?(result,error)
            })
        }
        else {
            retryCounter = 0
            User.createMe(userUid: currentFirUser!, user: currentFacebookUser)
            FBClient.currentFacebookUser = currentFacebookUser
            self.performSegue(withIdentifier: "postLogin", sender: self)

        }
    }
    

}

   


extension LoginScreenViewController {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        guard error == nil else {
            print (error!.localizedDescription)
            showAlert(title: "Login Error", message: "")
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            guard error == nil else {
                print (error ?? "")
                return
            }
            print ("User login with facebook")
        })
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        print ("User log out of facebook")
    }
}

extension LoginScreenViewController {
    
    func kickUserBackToMain() {
        self.performSegue(withIdentifier: "loginController", sender: self)
    }
    
    
    func showErrorMessage(error:Error, completionHandler:((Bool) -> ())?) {
//        LoadingOverlay.shared.hideOverlayView()
        
        self.showAlert(title: Strings.errorGraphRequestTitle, message:String(format:Strings.errorGraphRequestMessage, error.localizedDescription) , { (buttonIndex) in
            if self.retryCounter < self.maxRetries {
                completionHandler?(true)
            }
            else {
                completionHandler?(false)
                self.showAbortMessage(title: Strings.errorAbortTitle,message: Strings.errorAbortMessage)
            }
            
        }, buttonTitles:Strings.btnOK)
        
        self.retryCounter += 1
    }
    
    
    func showAbortMessage(title:String,message:String) {
//        LoadingOverlay.shared.hideOverlayView()
        self.showAlert(title: title, message:message ,
                       { (buttonIndex) in
                        self.kickUserBackToMain()
        }, buttonTitles:Strings.btnOK)
    }

    
    
}


extension UIViewController {
    func showAlert(title:String, message: String, _ completionHandler:((_ buttonPressed: Int?) -> Void)?, buttonTitles:String...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for buttonTitle in buttonTitles {
            alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let btnIndex = alertController.actions.index(of: action)
                completionHandler?(btnIndex)
            }))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}




protocol Alerts {
    func showAlert(title: String, message : String?)
}

extension UIViewController: Alerts {
    func showAlert(title: String, message : String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAndDismiss(title: String, message : String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

