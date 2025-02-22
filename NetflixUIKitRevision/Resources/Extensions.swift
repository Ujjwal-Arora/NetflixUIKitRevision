//
//  Extensions.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 16/02/25.
//

import Foundation

extension String{
    func capitalisedFirstLetter() -> String{
        self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}
