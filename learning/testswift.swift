import SwiftUI

// ViewModel for TestSwift
class TestSwiftViewModel: ObservableObject {
    @Published var userInputModel: UserInputModel
    @Published var countL: Int = 0
    @Published var countF: Int = 0
    @Published var isLearnedTodayClicked = false
    @Published var isFreezeDayClicked = false
    @Published var buttonsEnabled = true
    @Published var currentDate = Date()
    
    let calendar = Calendar.current

    init(userInputModel: UserInputModel) {
        self.userInputModel = userInputModel
    }

    var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    var currentDayInfo: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM"
        return formatter.string(from: currentDate)
    }

    var weekDays: [Date] {
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    func updateDate(byAddingMonths value: Int) {
        currentDate = calendar.date(byAdding: .month, value: value, to: currentDate) ?? currentDate
    }

    func updateDate(byAddingWeeks value: Int) {
        currentDate = calendar.date(byAdding: .weekOfYear, value: value, to: currentDate) ?? currentDate
    }

    func logLearnedToday() {
        if buttonsEnabled && !isFreezeDayClicked {
            isLearnedTodayClicked.toggle()
            if isLearnedTodayClicked {
                countL += 1
                buttonsEnabled = false
            }
        }
    }

    func freezeDay() {
        if buttonsEnabled {
            isFreezeDayClicked = true
            countF += 1
            buttonsEnabled = false
        }
    }

    func resetLearningPlan() {
        countL = 0
        countF = 0
        isLearnedTodayClicked = false
        isFreezeDayClicked = false
        buttonsEnabled = true
    }
}

struct TestSwift: View {
    @ObservedObject var userInputModel: UserInputModel
    @StateObject private var viewModel: TestSwiftViewModel

    init(userInputModel: UserInputModel) {
        self.userInputModel = userInputModel
        self._viewModel = StateObject(wrappedValue: TestSwiftViewModel(userInputModel: userInputModel))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.currentDayInfo)
                            .font(.title3)
                            .foregroundColor(Color("greyBG"))
                            .padding(.leading, -10)

                        HStack {
                            Text("Learning \(userInputModel.userInput)")
                                .font(.system(size: calculateFontSize(for: userInputModel.userInput)))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.leading, -10)

                            NavigationLink(destination: EditGoal(userInputModel: userInputModel)
                                            .environmentObject(viewModel)
                                            .onAppear {
                                                viewModel.resetLearningPlan() // Reset when going back
                                            }) {
                                Text("🔥")
                                    .font(.system(size: 20))
                                    .padding(5)
                                    .background(Color("greyBG"))
                                    .clipShape(Circle())
                                    .padding(.leading, 80)
                            }
                        }
                    }
                    .padding()

                    // Month Navigation
                    VStack {
                        HStack {
                            Button(action: {
                                viewModel.updateDate(byAddingMonths: -1)
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.orange)
                            }

                            Text(viewModel.currentMonthYear)
                                .font(.title3)
                                .padding(.horizontal, 5)
                                .foregroundColor(.white)

                            Button(action: {
                                viewModel.updateDate(byAddingMonths: 1)
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.orange)
                            }
                            
                            Spacer()

                            Button(action: {
                                viewModel.updateDate(byAddingWeeks: -1)
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.orange)
                            }

                            Button(action: {
                                viewModel.updateDate(byAddingWeeks: 1)
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.bottom, 5)

                        HStack(spacing: 10) {
                            ForEach(viewModel.weekDays, id: \.self) { date in
                                VStack {
                                    if viewModel.calendar.isDateInToday(date) {
                                        Circle()
                                            .fill(viewModel.isFreezeDayClicked ? Color.blue : (viewModel.isLearnedTodayClicked ? Color("orangeBG") : Color.clear))
                                            .frame(width: 30, height: 30)
                                            .overlay(
                                                Text("\(viewModel.calendar.component(.day, from: date))")
                                                    .foregroundColor(Color.white)
                                            )
                                    } else {
                                        Text("\(viewModel.calendar.component(.day, from: date))")
                                            .font(.system(size: 14))
                                            .padding(5)
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity)
                                    }
                                    Text(date, formatter: DateFormatter.shortDayFormatter)
                                        .font(.system(size: 10))
                                        .foregroundColor(viewModel.calendar.isDateInToday(date) ? Color.white : Color.gray)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }

                        Divider()
                            .background(Color.gray)
                            .padding(.vertical)

                        HStack {
                            VStack {
                                HStack {
                                    Text("\(viewModel.countL)")
                                        .font(.title)
                                        .foregroundColor(Color.white)
                                    Text("🔥")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                }
                                Text("Day Streak")
                                    .foregroundColor(Color("greyBG"))
                            }
                            .frame(maxWidth: .infinity)

                            Divider()
                                .frame(width: 2)
                                .background(Color("greyBG"))

                            VStack {
                                HStack {
                                    Text("\(viewModel.countF)")
                                        .font(.title)
                                        .foregroundColor(Color.white)
                                    Text("🧊")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                }
                                Text("Day Freezed")
                                    .foregroundColor(Color("greyBG"))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .padding(.bottom, 80)

                    VStack {
                        Circle()
                            .fill(viewModel.isFreezeDayClicked ? Color("darkBlueB") : (viewModel.isLearnedTodayClicked ? Color("brownbt") : Color("orangeBG")))
                            .frame(width: 250, height: 250)
                            .overlay(
                                Text(viewModel.isFreezeDayClicked ? "Day Freezed" : (viewModel.isLearnedTodayClicked ? "Learned\nToday" : "Log today\nas Learned"))
                                    .foregroundColor(viewModel.isFreezeDayClicked ? Color.blue : (viewModel.isLearnedTodayClicked ? Color("orangeBG") : Color.black))
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                            )
                            .onTapGesture {
                                viewModel.logLearnedToday()
                            }
                            .animation(.easeInOut, value: viewModel.isLearnedTodayClicked)
                            .animation(.easeInOut, value: viewModel.isFreezeDayClicked)
                            .padding(.top, -50)
                            .padding()

                        Button(action: {
                            viewModel.freezeDay()
                        }) {
                            Text("  Freeze day      ")
                                .font(.callout)
                                .padding()
                                .background(viewModel.buttonsEnabled ? Color("freezedayBT") : Color.gray)
                                .foregroundColor(viewModel.buttonsEnabled ? .blue : .white)
                                .cornerRadius(10)
                        }
                        .disabled(!viewModel.buttonsEnabled)

                        Text("\(viewModel.countF) out of 6 freezes used ")
                            .font(.footnote)
                            .foregroundColor(Color("greyBG"))
                    }
                }
            }
        }
        .accentColor(.orange) // Set back button color to orange
    }

    // Function to calculate font size based on input length
    private func calculateFontSize(for text: String) -> CGFloat {
        let baseSize: CGFloat = 24 // Base font size
        let maxTextLength: CGFloat = 30 // Maximum length before scaling down
        let textLength = CGFloat(text.count)
        
        // Scale the font down based on the length of the text
        if textLength > maxTextLength {
            return max(baseSize * (maxTextLength / textLength), 10) // Ensure a minimum font size
        }
        
        return baseSize // Return base size if within limit
    }
}

extension DateFormatter {
    static var shortDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
}

// Preview
#Preview {
    TestSwift(userInputModel: UserInputModel()) // Provide a valid instance
}
