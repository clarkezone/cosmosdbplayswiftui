import SwiftUI
import CryptoKit
import Foundation

func callCosmosDB(verb:String, accountName: String, masterKey: String, databaseId: String, collectionId: String, sqlQuery: String) async throws -> Any {
    let resourceType = "docs"
    let resourceId = "dbs/\(databaseId)/colls/\(collectionId)"
    //    let resourceType = "dbs"
    //let resourceId = ""
    //    let resourceLink = "dbs"
    let resourceLink = "dbs/\(databaseId)/colls/\(collectionId)/docs"
    
    let urlString = "https://\(accountName).documents.azure.com/dbs/\(databaseId)/colls/\(collectionId)/docs"
    //  let urlString = "https://\(accountName).documents.azure.com/dbs"
    guard let url = URL(string: urlString) else { throw NSError(domain: "Invalid URL", code: 1, userInfo: nil) }
    
    var request = URLRequest(url: url)
    request.httpMethod = verb
    
    let date = generateUTCDate()
    //let date = DateFormatter.azureDateFormatter.string(from: Date())
    request.addValue(date, forHTTPHeaderField: "x-ms-date")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/query+json", forHTTPHeaderField: "Content-Type")
    request.addValue("true", forHTTPHeaderField: "x-ms-documentdb-isquery")
    //    request.addValue("2018-12-31", forHTTPHeaderField: "x-ms-version") // Add the x-ms-version header with the appropriate version value
    request.addValue("2015-08-06", forHTTPHeaderField: "x-ms-version") // Add the x-ms-version header with the appropriate version value
    request.addValue("true", forHTTPHeaderField: "x-ms-documentdb-query-enablecrosspartition")
    
    
    //    if let authToken = generateAuthToken(verb: verb, resourceId: resourceId, resourceType: resourceType, date: date, masterKey: masterKey) {
    //request.addValue(authToken, forHTTPHeaderField: "Authorization")
    //}
    
    if let authToken = generateMasterKeyAuthorizationSignature(verb:verb, resourceId: resourceId, resourceType: resourceType, key: masterKey, keyType: "master", tokenVersion: "1.0") {
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
    }
    
    let queryPayload = [
        "query": sqlQuery
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: queryPayload, options: [])
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    return json
}


func generateUTCDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    return dateFormatter.string(from: Date())
}

private func generateMasterKeyAuthorizationSignature(verb: String, resourceId: String, resourceType: String, key: String, keyType: String, tokenVersion: String) -> String? {
    let utcDate = generateUTCDate()
    let keyData = Data(base64Encoded: key)!
    let symmetricKey = SymmetricKey(data: keyData)
    
    let payload = "\(verb.lowercased())\n\(resourceType.lowercased())\n\(resourceId)\n\(utcDate.lowercased())\n\n"
    
    let hashedPayload = HMAC<SHA256>.authenticationCode(for: payload.data(using: .utf8)!, using: symmetricKey)
    let signature = Data(hashedPayload).base64EncodedString()
    
    let authString = "type=\(keyType)&ver=\(tokenVersion)&sig=\(signature)"
    
    return authString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
}
