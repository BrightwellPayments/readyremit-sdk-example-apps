//
//  CreateTransferResponse.swift
//  ReadyRemitHost
//
//  Created by Matthew Mohrman on 10/23/25.
//

import ReadyRemitSDK

struct CreateTransferResponse: Decodable {
    let transferId: String
}

extension CreateTransferResponse: TransferDetails { }
