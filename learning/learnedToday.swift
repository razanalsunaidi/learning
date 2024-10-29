import SwiftUI

struct LearnedToday: View {
    
    @State private var count: Int = 0
    @State private var isLearnedTodayClicked = false
    @State private var isFreezeDayClicked = false
    @State private var buttonsEnabled = true
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                Circle()
                    .fill(isFreezeDayClicked ? Color.blue : (isLearnedTodayClicked ? Color("brownbt") : Color("orangeBG")))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Text(isFreezeDayClicked ? "Day Freezed" : (isLearnedTodayClicked ? "Learned\nToday" : "Log today\nas Learned"))
                            .foregroundColor(isFreezeDayClicked || isLearnedTodayClicked ? Color("orangeBG") : Color.white)
                        
                            .multilineTextAlignment(.center)
                            .font(.title)
                    )
                    .onTapGesture {
                        if buttonsEnabled && !isFreezeDayClicked {
                            isLearnedTodayClicked.toggle()
                            if isLearnedTodayClicked {
                                buttonsEnabled = false
                            }
                        }
                    }
                    .animation(.easeInOut, value: isLearnedTodayClicked)
                    .padding()
                
                Button(action: {
                    if buttonsEnabled {
                        isFreezeDayClicked = true
                        count+=1
                        buttonsEnabled = false
                    }
                }) {
                    Text("  Freeze day      ")
                        .font(.callout)
                        .padding()
                        .background(buttonsEnabled ? Color("freezedayBT") : Color.gray)
                        .foregroundColor(buttonsEnabled ? .blue : .white)
                        .cornerRadius(10)
                }
                .disabled(!buttonsEnabled) // Disable button if not enabled
                
                Text("\(count) out of 6 freezes used ")
                    .font(.footnote)
                    .foregroundColor(Color("greyBG"))
            }
            .padding()
        }
    }
}

#Preview {
    LearnedToday()
}
