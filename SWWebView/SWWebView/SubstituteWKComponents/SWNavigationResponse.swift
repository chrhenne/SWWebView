//
//  SWNavigationResponse.swift
//  SWWebView
//
//  Created by alastair.coote on 07/08/2017.
//  Copyright © 2017 Guardian Mobile Innovation Lab. All rights reserved.
//

import Foundation
import WebKit

class SWNavigationResponse : WKNavigationResponse {
    
    fileprivate let _canShowMIMEType: Bool
    override var canShowMIMEType: Bool {
        get {
            return self._canShowMIMEType
        }
    }
    
    fileprivate let _isForMainFrame:Bool
    override var isForMainFrame: Bool {
        get {
            return self._isForMainFrame
        }
    }
    
    fileprivate let _response: URLResponse
    override var response: URLResponse {
        get {
            return self._response
        }
    }
    
    init(response: URLResponse, isForMainFrame: Bool, canShowMIMEType: Bool) {
        self._response = response
        self._isForMainFrame = isForMainFrame
        self._canShowMIMEType = canShowMIMEType
    }
}
