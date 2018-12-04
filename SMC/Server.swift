//
//  Server.swift
//  SMC
//
//  Created by JuicePhactree on 11/16/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class Server: NSObject {
    
    class func uploadVideoToServer(videoData: NSData,uniqueId: String , completion: ((NSDictionary) -> Swift.Void)? = nil, faliure: ((String) -> Swift.Void)? = nil) {
        
        let myUrl = NSURL(string: "\(STORE_VIDEO_URL)");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let reduceSizePicture = profileImg.image?.resizeWith(width: 200)
        
        request.httpBody = createVideoBodyWithParameters(parameters: nil, filePathKey: "file", videoDataKey: videoData as NSData, boundary: boundary, uniqueId: uniqueId) as Data
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("Arslan PorfilePictureVC : Error \(String(describing: error))")
                faliure!("not deliverd")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Arslan PorfilePictureVC : Response Data  \(responseString!)")
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let parseJSON = json {
                    if parseJSON["message"].debugDescription.contains("has been uploaded") {
                        completion!(parseJSON)
                    }
                    else {
                        faliure!("not deliverd")
                    }
                    //completion!(parseJSON)
                }
                
            }catch{
                faliure!("not deliverd")
                print("Arslan ProfilePictureVC : There was something wrong while uploading the picture to the server \(error)")
            }
            DispatchQueue.main.async {
            }
        }
        
        task.resume()
        
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    class func createVideoBodyWithParameters(parameters: [String: String]?, filePathKey: String?, videoDataKey: NSData, boundary: String, uniqueId: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let filename = uniqueId+".mp4"
        let mimetype = "video/mp4"
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(videoDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

