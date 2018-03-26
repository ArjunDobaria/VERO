//
//  APIManager.swift
//  VERO
//
//  Created by lanet on 06/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

public class Service_Call {
    static let sharedInstance = Service_Call()
    
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //MARK:- Base get Service Request
    func serviceGet(_ url : String, successBlock : @escaping (_ response : Any) -> Void, failureBlock : @escaping (_ error : String) -> Void)
    {
        if Service_Call.isConnectedToNetwork(){
            print("Requested URL : \(url)")
            let url : URL = URL(string : url)!
            let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = session.dataTask(with: request){ (data, response, error) in
                if response != nil
                {
                    if (response)!.value(forKey: "statusCode")as? Int == 200
                    {
                        let res = try? JSONSerialization.jsonObject(with: data!, options: [])
                        successBlock(res!)
                    }
                    else
                    {
                        failureBlock((error?.localizedDescription)!)
                    }
                    
                }
                else
                {
                    failureBlock((error?.localizedDescription)!)
                }
            }
            task.resume()
        }
        else{
            print("Network in not connected")
        }
    }
    
    func servicePost(_ url : String, param : [String : Any], successBlock : @escaping (_ response : Any) -> Void, failureBlock : @escaping (_ error : String) -> Void)
    {
        if Service_Call.isConnectedToNetwork(){
            print("Requested URL : \(url)")
            let url : URL = URL(string : url)!
            let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let params : [String : Any] = param
            do{request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])}catch let error as NSError{print(error)}
            let task = session.dataTask(with: request){ (data, response, error) in
                if response != nil
                {
                    if (response)!.value(forKey: "statusCode")as? Int == 200
                    {
                        let res = try? JSONSerialization.jsonObject(with: data!, options: [])
                        successBlock(res!)
                    }
                    else
                    {
                        failureBlock((error?.localizedDescription)!)
                    }
                    
                }
                else
                {
                    failureBlock((error?.localizedDescription)!)
                }
            }
            task.resume()
        }
        else{
            print("Network in not connected")
        }
    }
    
    func serviceUploadImgWithDataPost(_ img : UIImage, url : String, param :[String : Any],userId : String, successBlock : @escaping (_ response : Any) -> Void, failureBlock : @escaping (_ error : String) -> Void) {
            let imageData = UIImageJPEGRepresentation(img, 1.0)
            
            let urlString = url
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let mutableURLRequest = NSMutableURLRequest(url: URL(string: urlString)!)
            
            mutableURLRequest.httpMethod = "POST"
            
            let boundaryConstant = UUID().uuidString;
            let contentType = "multipart/form-data;boundary=" + boundaryConstant
            mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            // create upload data to send
            let uploadData = NSMutableData()
//            if(param != nil){
                for (key, value) in param {
                    uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                    uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    uploadData.append("\(value)".data(using: String.Encoding.utf8)!)
                }
//            }
            // add image
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"userPhoto\"; filename=\"\(userId)\"\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append(imageData!)
            uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
            
            mutableURLRequest.httpBody = uploadData as Data
            
            
            let task = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                if(error == nil)
                {
                    let res = try? JSONSerialization.jsonObject(with: data!, options: [])
                    successBlock(res!)
                }
                else
                {
                    failureBlock((error?.localizedDescription)!)
                }
            })
            
            task.resume()
    }
    
}
