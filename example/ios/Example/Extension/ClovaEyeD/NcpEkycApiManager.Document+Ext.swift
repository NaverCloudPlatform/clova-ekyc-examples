//
//  NcpEkycApiManager.Document+Ext.swift
//  NcpExample
//
//  Created by vdc_app on 10/9/25.
//

import ClovaEyeD

extension NcpEkycApiManager.Document {
    mutating func appendSerialNumberFieldIfMissing() {
        if result.pp?["serialNum"] == nil {
            if var firstValue = result.pp?.values.first?.first {
                firstValue.text = ""
                result.pp?["serialNum"] = [firstValue]
            }
        }
        
        if result.ic?["serialNum"] == nil {
            if var firstValue = result.ic?.values.first?.first {
                firstValue.text = ""
                result.ic?["serialNum"] = [firstValue]
            }
        }
        
        if result.dl?["serialNum"] == nil {
            if var firstValue = result.dl?.values.first?.first {
                firstValue.text = ""
                result.dl?["serialNum"] = [firstValue]
            }
        }
        
        if result.ac?["serialNum"] == nil {
            if var firstValue = result.ac?.values.first?.first {
                firstValue.text = ""
                result.ac?["serialNum"] = [firstValue]
            }
        }
    }
}
