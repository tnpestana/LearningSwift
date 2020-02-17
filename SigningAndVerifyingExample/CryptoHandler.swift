//
//  CryptoHandler.swift
//  SigningAndVerifyingExample
//
//  Created by Tiago Pestana on 16/02/2020.
//  Copyright © 2020 Tiago Pestana. All rights reserved.
//

import Foundation

class CryptoHandler {
    static var signingPrivateKeyTag: String = "SigningPrivateKeyTag"
    static var algorithm: SecKeyAlgorithm = .ecdsaSignatureRFC4754 //rsaSignatureMessagePKCS1v15SHA512
    
    static func generateSingningKey() -> SecKey? {
        let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .privateKeyUsage,
            nil)!
        
        let attributes: [String: Any] = [
          kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
          kSecAttrKeySizeInBits as String: 256,
          kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
          kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: CryptoHandler.signingPrivateKeyTag,
            kSecAttrAccessControl as String: access
          ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print("error creating key")
            return nil
        }
        
        return privateKey
    }
    
    static func signMessage(message: String) -> (signature: String?, data: String?)? {
        let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .privateKeyUsage,
            nil)!
        
        let attributes: [String: Any] = [
          kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
          kSecAttrKeySizeInBits as String: 256,
          kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
          kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: CryptoHandler.signingPrivateKeyTag,
            kSecAttrAccessControl as String: access
          ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print("error creating key")
            return nil
        }
        
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            print("private key signing algorithm not supported")
            return nil
        }
        
        let data = message.data(using: .utf8)!
        guard let signature = SecKeyCreateSignature(
            privateKey,
            algorithm,
            data as CFData,
            &error) as Data? else {
            print("error singing data")
            return nil
        }
        
        return (signature.base64EncodedString(), data.base64EncodedString())
    }
    
    static func verifySignature(publicKey: SecKey, data: String, signature: String) -> Bool {
        guard SecKeyIsAlgorithmSupported(publicKey, .verify, algorithm) else {
            print("public key signing algorithm not supported")
            return false
        }
        
        guard
            let decodedData = Data(base64Encoded: data),
            let decodedSignature = Data(base64Encoded: signature)
        else {
            print("unable to decode data or signature")
            return false
        }
        
        var error: Unmanaged<CFError>?
        guard SecKeyVerifySignature(
            publicKey,
            algorithm,
            decodedData as CFData,
            decodedSignature as CFData,
            &error) else {
            print("error verifying signature")
            print(error?.takeRetainedValue().localizedDescription as Any)
            return false
        }
        return true
    }
    
    static func getPublicKey(with privateKey: SecKey) -> SecKey? {
        return SecKeyCopyPublicKey(privateKey)
    }
    
    static func loadKey(name: String) -> SecKey? {
        let tag = name.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecReturnRef as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        return (item as! SecKey)
    }
}
