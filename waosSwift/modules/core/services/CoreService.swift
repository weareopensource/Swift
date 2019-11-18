//
//  Service.swift
//  RxTodo
//
//  Created by Suyeol Jeon on 12/01/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

class CoreService {
    unowned let provider: AppServicesProviderType

    init(provider: AppServicesProviderType) {
        self.provider = provider
    }
}
