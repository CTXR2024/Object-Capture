//
//  CircleCheckboxView.swift
//  ObjectCapture
//
//  Created by 洪聪志 on 2024/4/2.
//

import SwiftUI


struct CircleCheckboxView: View {
   var isChecked = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle().fill(Color.init(red: 88/255, green: 88/255, blue: 88/255))
                if isChecked {
                    Circle()
                        .fill(Color.gray).frame(width: 10, height: 10)
                }
            }
            .frame(width: 24, height: 24)
//            .onTapGesture {
//                isChecked.toggle()
//            }
            
        }
    }
}

struct CircleCheckboxView_Previews: PreviewProvider {
    static var previews: some View {
        CircleCheckboxView()
    }
}

#Preview {
    CircleCheckboxView()
}
