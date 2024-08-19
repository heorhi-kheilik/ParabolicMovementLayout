//
//  RootView.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 4.08.24.
//

import SwiftUI

@MainActor
protocol RootViewDelegate: AnyObject {
    func programmaticImplementationTouchUpInside()
    func xibImplementationTouchUpInside()
}

struct RootView: View {

    weak var delegate: RootViewDelegate?

    var body: some View {
        NavigationView {
            Form {
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
                }
            }
            .navigationTitle("Choose Implementation")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

#Preview {
    RootView()
}
