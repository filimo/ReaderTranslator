//
//  CMTime.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 28/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

extension CMTime {
    static func + (lhs: CMTime, rhs: TimeInterval) -> CMTime {
        return CMTime(seconds: lhs.seconds + rhs,
                      preferredTimescale: lhs.timescale)
    }

    static func += (lhs: inout CMTime, rhs: TimeInterval) {
        lhs = CMTime(seconds: lhs.seconds + rhs,
                      preferredTimescale: lhs.timescale)
    }

}
