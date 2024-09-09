//
//  RootView.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 4.08.24.
//

import SwiftUI

@MainActor
protocol RootViewDelegate: AnyObject {
    func realExampleTouchUpInside()
    func programmaticImplementationTouchUpInside()
    func xibImplementationTouchUpInside()
}

struct RootView: View {

    weak var delegate: RootViewDelegate?

    var body: some View {
        Form {
            Section {
                Button {
                    delegate?.realExampleTouchUpInside()
                } label: {
                    Text("Real Example")
                }
            }

            Section {
                Button {
                    delegate?.programmaticImplementationTouchUpInside()
                } label: {
                    Text("Programmatic")
                }

                Button {
                    delegate?.xibImplementationTouchUpInside()
                } label: {
                    Text("XIB")
                }
            } header: {
                Text("Implementations")
            }
        }
    }

}

#Preview {
    RootView()
}
