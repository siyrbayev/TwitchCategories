//
//  Nework.swift
//  TwitchCategories
//
//  Created by ADMIN ODoYal on 26.05.2021.
//

import Foundation
import Alamofire

open class NetworkConnection {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
