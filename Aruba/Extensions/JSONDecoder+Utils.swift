//
//  JSONDecoder+Utils.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import Alamofire

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print("⛔️ Response has errors: ", response.error!)
            return .failure(response.error!)
        }

        guard let responseData = response.data else {
            print("⛔️ Didn't get any data from API")
            return .failure(HTTPClient.ApiError.noData)
        }

        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("⛔️  Error trying to decode response: ", error)
            return .failure(error)
        }
    }
}
