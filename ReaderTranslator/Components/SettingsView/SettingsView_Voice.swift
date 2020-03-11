//
//  StatusBarView_Voice.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SettingsView_Voice: View {
    var body: some View {
        VStack {
            HStack {
                SettingsView_Voice_Select()
                SettingsView_Voice_Favorite()
            }
            SettingsView_Voice_Toggle()
            SettingsView_Voice_Rate()
        }
    }
}

struct StatusBarView_Voice_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView_Voice()
    }
}
