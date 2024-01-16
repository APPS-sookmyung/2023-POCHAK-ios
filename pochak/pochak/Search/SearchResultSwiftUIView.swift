//
//  SearchResultSwiftUIView.swift
//  pochak
//
//  Created by 장나리 on 1/10/24.
//

import SwiftUI

struct SearchResultSwiftUIView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        let view = SearchResultViewController()
        return view.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view when needed
    }
}
