//
//  String+URL.swift
//  RxExample
//
//  Created by kuroky on 2019/4/23.
//  Copyright © 2019 Emucoo. All rights reserved.
//

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
