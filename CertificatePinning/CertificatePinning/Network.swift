//
//  Network.swift
//  CertificatePinning
//
//  Created by Tiago Pestana on 20/02/2020.
//  Copyright © 2020 Tiago Pestana. All rights reserved.
//

import Foundation

class Network {
    func networkCall() {
        if let url = URL(string: "https://www.google.com/") {
            let session = URLSession(
                configuration: URLSessionConfiguration.ephemeral,
                delegate: URLSessionPinningDelegate(),
                delegateQueue: nil)
            
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("error: \(error!.localizedDescription))")
                } else if data != nil {
                    if let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        print("Received data:\n\(str)")
                    }
                    else {
                        print("Unable to convert data to text")
                    }
                }
            })
            
            task.resume()
        }
        else {
            print("Unable to create NSURL")
        }
    }
}
