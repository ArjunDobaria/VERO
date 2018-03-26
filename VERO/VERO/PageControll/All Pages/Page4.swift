//
//  Page4.swift
//  VERO
//
//  Created by lanet on 06/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class Page4: UIViewController {

    @IBOutlet weak var userMobiletxt: UITextField!
    @IBOutlet weak var sendOTPBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sendOTPBtn.isEnabled = false
        self.hideKeyboardWhenTappedAround() 
        userMobiletxt.addTarget(self, action: #selector(txtChanged(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc func txtChanged(_ text : UITextField){
        if(userMobiletxt.text!.description.count == 10)
        {
            sendOTPBtn.isEnabled = true
        }
    }
    
    
    @IBAction func sendOTPBtn(_ sender: Any) {
        
        //OTP screen
        UserDefaults.standard.set(userMobiletxt.text!, forKey: "userId")
        let param : [String : Any] = ["userId" : "91"+userMobiletxt.text!
                                      ]
       Service_Call.sharedInstance.servicePost(WebApi.API_LOGIN, param: param, successBlock:
        {(response) in
            print((response as! NSDictionary)["message"] as! Int)
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
       }, failureBlock:
        {(error) in
            AppDelegate().sharedDelegate().myWarnningAlert(error)
       })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
