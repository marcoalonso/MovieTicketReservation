//
//  CustomTabBar.swift
//  Movie Booking Reservation
//
//  Created by Marco Alonso Rodriguez on 04/04/23.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: Tab
    
    ///Continuar en min 35:00
    /// https://www.youtube.com/watch?v=EkcKeGQm3_U&t=166s
    
    var body: some View {
        HStack(spacing: 0.0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button {
                    withAnimation(.easeOut) {
                        currentTab = tab
                    }
                } label: {
                    Image(tab.rawValue)
                        .renderingMode(.template)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }

                
                
                
            }
        }
        .frame(maxWidth: .infinity)
        .background(.red)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
