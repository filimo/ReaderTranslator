//
//  test.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 27/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State var pp = 1
    @State var show = false

    var body: some View {
        VStack {
//            Spacer()
            Text("1000")
                .onTapGesture {
                    self.show = true
                }
                .overlay(
                    Group {
                        if show {
                            Picker(selection: $pp, label: Text("")) {
                                Text("1111").tag(1)
                                Text("1111").tag(2)
                                Text("1111").tag(3)
                                Text("1111").tag(4)
                                Text("1111").tag(5)
                            }
                            .background(Color.secondary)
                            .foregroundColor(Color.primary)
                        } else {
                            EmptyView()
                        }
                    }
                )
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
