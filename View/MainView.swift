//
//  OnboardingView.swift
//  KGN
//
//  Created by Mark L. Watson on 6/20/21.
// Note: to forget window size/placement, in command line: defaults delete markwatson.com.KGN


import SwiftUI

struct MainView: View {
    var body: some View {
       TabView {
        QueryView().padding()
            .tabItem {
                //Image(imageLiteralResourceName: "1.circle")
                Text("Query")
            }.tag(1)
        InfoView().padding()
            .tabItem {
                //Image(imageLiteralResourceName: "1.circle")
                Text("Info")
            }.tag(2)
        AboutView().padding()
            .tabItem {
                //Image(imageLiteralResourceName: "1.circle")
                Text("About")
            }.tag(3)
       } //: TAB
       //.tabViewStyle(PageTabViewStyle()) // iOS only
       .padding(.vertical, 20)
     }}

