//
//  Color.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import SwiftUI

extension Color {

  static var random: Color {
    return Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }

}
