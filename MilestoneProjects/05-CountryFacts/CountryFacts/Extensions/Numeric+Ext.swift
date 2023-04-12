//
//  Numeric+Ext.swift
//  CountryFacts
//
//  Created by JC on 12/4/23.
//

import Foundation

extension Numeric {
    
    func formattedWithSeparator() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        // Establece el separador de grupo basado en la configuración regional
        numberFormatter.groupingSeparator = Locale.current.groupingSeparator

        // Establece el tamaño del grupo basado en la configuración regional
        numberFormatter.groupingSize = 3

        return numberFormatter.string(for: self)
    }
    
}
