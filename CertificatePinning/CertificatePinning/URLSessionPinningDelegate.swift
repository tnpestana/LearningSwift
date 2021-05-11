//
//  URLSessionPinningDelegate.swift
//  CertificatePinning
//
//  Created by Tiago Pestana on 20/02/2020.
//  Copyright © 2020 Tiago Pestana. All rights reserved.
//

import Foundation
import Security
import CommonCrypto

class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    private static let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ];

    private static let google_com_pubkey = ["4xVxzbEegwDBoyoGoJlKcwGM7hyquoFg4l+9um5oPOI="];
    private static let google_com_full = ["KjLxfxajzmBH0fTH1/oujb6R5fqBiLxl0zrl2xyFT2E="];

    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return;
        }

        // Set SSL policies for domain name check
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)));
        SecTrustSetPolicies(serverTrust, policies);

        //var isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil);
        var secresult = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust, &secresult)
        var isServerTrusted = (status == errSecSuccess)

        if(isServerTrusted && challenge.protectionSpace.host == "www.google.com") {
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
            //Compare public key
            let policy = SecPolicyCreateBasicX509();
            let cfCertificates = [certificate] as CFArray;

            var trust: SecTrust?
            SecTrustCreateWithCertificates(cfCertificates, policy, &trust);

            guard trust != nil, let pubKey = SecTrustCopyPublicKey(trust!) else {
                completionHandler(.cancelAuthenticationChallenge, nil);
                return;
            }

            var error:Unmanaged<CFError>?
            if let pubKeyData = SecKeyCopyExternalRepresentation(pubKey, &error) {
                var keyWithHeader = Data(URLSessionPinningDelegate.rsa2048Asn1Header);
                keyWithHeader.append(pubKeyData as Data);
                let sha256Key = sha256(data: keyWithHeader);
                if(!Constants.CertificatePinning.PublicKey.contains(sha256Key)) {
                    isServerTrusted = false;
                }
            }
            else {
                isServerTrusted = false;
            }
//            //Compare full certificate
//            let remoteCertificateData = SecCertificateCopyData(certificate!) as Data;
//            let sha256Data = sha256(remoteCertificateData);
//            if(!Constants.CertificatePinning.Certificate.contains(sha256Data)) {
//                isServerTrusted = false;
//            }
        
        }

        if(isServerTrusted) {
            let credential = URLCredential(trust: serverTrust);
            completionHandler(.useCredential, credential);
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil);
        }

    }
    
    func sha256(data : Data) -> String {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
}
