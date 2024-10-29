import SwiftUI

// ViewModel for EditGoal
class EditGoalViewModel: ObservableObject {
    @Published var userInputModel: UserInputModel
    @Published var selectedDuration: String? = nil

    init(userInputModel: UserInputModel) {
        self.userInputModel = userInputModel
    }

    func updateGoal() {
        // Print the updated values
        print("Updated Goal: \(userInputModel.userInput), Duration: \(selectedDuration ?? "None")")
    }
}

struct EditGoal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInputModel: UserInputModel
    @StateObject private var viewModel: EditGoalViewModel

    init(userInputModel: UserInputModel) {
        self.userInputModel = userInputModel
        self._viewModel = StateObject(wrappedValue: EditGoalViewModel(userInputModel: userInputModel))
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header with Update Button
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.updateGoal() // Call the ViewModel's update function
                        presentationMode.wrappedValue.dismiss() // Dismiss the current view
                    }) {
                        Text("Update")
                            .padding()
                            .foregroundColor(Color("orangeBG"))
                            .cornerRadius(5)
                    }
                    .padding()
                }
                
                // Input Section
                VStack(alignment: .leading) {
                    Text("I want to learn")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    // Text Field bound to userInputModel
                    TextField("Enter your goal", text: $viewModel.userInputModel.userInput)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .accentColor(.orange) // Changes the cursor color
                        .cornerRadius(5)
                        .padding(.top, 20)
                    
                    Divider()
                        .background(Color.white)
                    
                    Text("I want to learn it in a")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    // Radio Buttons for duration selection
                    HStack {
                        ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                            Button(action: {
                                viewModel.selectedDuration = duration
                            }) {
                                Text(duration)
                                    .frame(width: 100, height: 50)
                                    .background(viewModel.selectedDuration == duration ? Color("orangeBG") : Color("greyBG"))
                                    .foregroundColor(viewModel.selectedDuration == duration ? .black : .gray)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

// Preview
struct EditGoal_Previews: PreviewProvider {
    static var previews: some View {
        let userInputModel = UserInputModel()
        return EditGoal(userInputModel: userInputModel)
    }
}
