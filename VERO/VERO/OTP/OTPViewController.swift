//
//  OTPViewController.swift
//  VERO
//
//  Created by lanet on 06/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var activityIndecatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField2: UITextField!
    @IBOutlet weak var txtField3: UITextField!
    @IBOutlet weak var txtField4: UITextField!
    @IBOutlet weak var txtField5: UITextField!
    @IBOutlet weak var txtField6: UITextField!
    
    @IBOutlet weak var resendOTPlbl: UILabel!
    @IBOutlet weak var callMelbl: UILabel!
    
    @IBOutlet weak var callMebtn: UIButton!
    @IBOutlet weak var resendOTPbtn: UIButton!
    
    //MARK:- Valriables
    
    var timer: Timer!;
    var counter: Int = 60;
    var total: Int = 0;
    var mobileNumber = ""
    var blurEffect : UIBlurEffect = UIBlurEffect()
    var blurEffectView : UIVisualEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.hideKeyboardWhenTappedAround() 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        self.title = "Verify OTP"
        
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("Done", for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        timer = nil
        timerStart()
        activityIndecatorView.translatesAutoresizingMaskIntoConstraints = true
        activityIndecatorView.center = self.view.center
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        statusLabel.text = "Connecting"
        activityIndicator.isHidden = true
        statusLabel.isHidden = true
        
        txtField1.attributedPlaceholder = NSAttributedString(string: "-",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        txtField2.attributedPlaceholder = NSAttributedString(string: "-",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        txtField3.attributedPlaceholder = NSAttributedString(string: "-",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        txtField4.attributedPlaceholder = NSAttributedString(string: "-",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        txtField5.attributedPlaceholder = NSAttributedString(string: "-",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        txtField6.attributedPlaceholder = NSAttributedString(string: "-",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        
        txtField1.addTarget(self, action: #selector(txt1), for: .editingChanged)
        txtField2.addTarget(self, action: #selector(txt2), for: .editingChanged)
        txtField3.addTarget(self, action: #selector(txt3), for: .editingChanged)
        txtField4.addTarget(self, action: #selector(txt4), for: .editingChanged)
        txtField5.addTarget(self, action: #selector(txt5), for: .editingChanged)
        txtField6.addTarget(self, action: #selector(txt6), for: .editingChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK:- Custome Functions
    
    func blur() {
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        statusLabel.isHidden = false
        statusLabel.text = "Connecting.."
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        blurEffectView.contentView.addSubview(activityIndecatorView)
        self.view.addSubview(blurEffectView)
    }
    
    @objc func txt1(_ textField: UITextField) {
        if(txtField1.text?.description.count == 1){
            txtField1.resignFirstResponder()
            txtField2.becomeFirstResponder()
        }
        else{
            txtField1.becomeFirstResponder()
        }
    }
    
    @objc func txt2(_ textField: UITextField) {
        if(txtField2.text?.description.count == 1){
            txtField2.resignFirstResponder()
            txtField3.becomeFirstResponder()
        }
        else{
            txtField2.becomeFirstResponder()
        }
    }
    
    @objc func txt3(_ textField: UITextField) {
        if(txtField3.text?.description.count == 1){
            txtField3.resignFirstResponder()
            txtField4.becomeFirstResponder()
        }
        else{
            txtField3.becomeFirstResponder()
        }
    }
    
    @objc func txt4(_ textField: UITextField) {
        if(txtField4.text?.description.count == 1){
            txtField4.resignFirstResponder()
            txtField5.becomeFirstResponder()
        }
        else{
            txtField4.becomeFirstResponder()
        }
    }
    
    @objc func txt5(_ textField: UITextField) {
        if(txtField5.text?.description.count == 1){
            txtField5.resignFirstResponder()
            txtField6.becomeFirstResponder()
        }
        else{
            txtField5.becomeFirstResponder()
        }
    }
    
    
    @objc func txt6(_ textField: UITextField) {
        if(txtField6.text?.description.count == 1){
            txtField6.resignFirstResponder()
            //MARK:- Send OTP
            //service call for checking OTP code
            let OTP : String = txtField1.text!+txtField2.text!+txtField3.text!+txtField4.text!+txtField5.text!+txtField6.text!
            let userId = "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
            let param : [String : Any] = ["otp" : OTP, "userId" : userId]
            Service_Call.sharedInstance.servicePost(WebApi.API_VERIFY, param: param, successBlock:
                {(response) in
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "isOTPVerify")
                        UserDefaults.standard.synchronize()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
            }, failureBlock:
                {(error) in
                    UserDefaults.standard.set(false, forKey: "isOTPVerify")
                    UserDefaults.standard.synchronize()
                    AppDelegate().sharedDelegate().myWarnningAlert(error)
            })
        }
        else{
            txtField6.becomeFirstResponder()
        }
    }
    //MARK:- Resend OTP
    @IBAction func resendOTPBtn(_ sender: Any) {
        //Resend OTP on that number
        let param : [String : Any] = ["userId" : "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
        ]
        Service_Call.sharedInstance.servicePost(WebApi.API_LOGIN, param: param, successBlock:
            {(response) in
                    print((response as! NSDictionary)["message"] as! Int)
        }, failureBlock:
            {(error) in
                print(error)
        })
    }
    
    func reset(){
        txtField1.text = ""
        txtField2.text = ""
        txtField3.text = ""
        txtField4.text = ""
        txtField5.text = ""
        txtField6.text = ""
    }
    
    func timerStart() {
        if(timer == nil) {
            timer = Timer.init(timeInterval: 1, target: self, selector: #selector(timerFunction(_:)), userInfo: nil, repeats: true);
            let runloop: RunLoop = RunLoop.current;
            runloop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
        }
    }
    
    @objc func timerFunction(_ atimer:Timer) {
        counter -= 1;
        resendOTPlbl.text = "Resend Code in 0:\(counter)"
        callMelbl.text = "Call Me in 0:\(counter)"
        
        if counter < 10 {
            resendOTPlbl.text = "Resend Code in 0:0\(counter)"
            callMelbl.text = "Call Me in 0:0\(counter)"
        }
        
        if(counter == total) {
            timer.invalidate();
            self.callMebtn.isHidden = false
            self.resendOTPbtn.isHidden = false
            self.callMelbl.isHidden = true
            self.resendOTPlbl.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
