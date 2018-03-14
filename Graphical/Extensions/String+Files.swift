//
//  String+Files.swift
//  Graphical
//
//  Created by Robert Caraway on 3/1/18.
//  Copyright © 2018 Rob Caraway. All rights reserved.
//

import Foundation

public extension String {
    public static func temporaryMovieFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        guard let cacheDirectory = paths.first else { return "" }
        let fileName = "\(cacheDirectory)/\(arc4random()%10000)movie.mov"
        return fileName
    }
}
