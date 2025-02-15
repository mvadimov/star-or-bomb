import SwiftUI
import AudioToolbox

struct ContentView: View {
    @State private var isFlipped = false
    @State var bombs = 4
    @State var xyBomb = [[]]
    @State var field: [[Cell]] = []
    @State var score = 0
    @State var youWin = false
    @State var youLose = false
    
    var body: some View {
        VStack {
            VStack(spacing: 5){
                Text("Star or Bomb")
                    .frame(width: UIScreen.main.bounds.width / 1.25, alignment: .leading)
                    .font(.system(size: 25))
                    .foregroundStyle(Color.sqBlue1)
                    .fontWeight(.bold)
                
                HStack(spacing: 7){
                    Text("Score: ")
                        .font(.system(size: 19))
                        .foregroundStyle(Color.sqBlue2)
                        .fontWeight(.medium)
                    
                    Text(String(score))
                        .font(.system(size: 19))
                        .foregroundStyle(Color.sqBlue1)
                        .fontWeight(.bold)
                }
                .frame(width: UIScreen.main.bounds.width / 1.25, alignment: .leading)
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 10){
                ForEach(field.indices, id: \.self){ row in
                    HStack(spacing: 10){
                        ForEach(field[row].indices, id: \.self){ column in
                            if !field[row][column].isOpen{
                                Rectangle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.sqBlue1, Color.sqBlue2]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(15)
                                    .shadow(color: Color.white.opacity(0.05), radius: 20, y: 10)
                                    .onTapGesture{
                                        field[row][column].isOpen = true
                                        
                                        if !field[row][column].hasBomb {
                                            score += 10
                                            if score == 210 {
                                                youWin = true
                                                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)){}
                                            }
                                        }
                                        else {
                                            youLose = true
                                            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)){}
                                        }
                                    }
                            }
                            else {
                                if field[row][column].hasBomb{
                                    Image("bomb")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                                else {
                                    ZStack{
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.starFirst1, Color.starFirst2]), startPoint: .top, endPoint: .bottom))
                                            
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.starSec1, Color.starSec2]), startPoint: .top, endPoint: .bottom))
                                    }
                                    .frame(width: 50, height: 50)
                                }
                            }
                        }
                    }
                }
            }
            .padding(20)
            .background(Color.bgBlue)
            .cornerRadius(5)
            .padding(5)
            .background(LinearGradient(gradient: Gradient(colors: [Color.sqBorderBlue, Color.bgBlue]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(10)
            
        }
        .alert("Congratulations!", isPresented: $youWin) {
            Button("Play Again") {
                makeField(bombs)
            }
        } message: {
            Text("You won! Your score: \(score)")
        }
        
        .alert("Game Over!", isPresented: $youLose){
            Button("Play Again") {
                makeField(bombs)
            }
        } message: {
            Text("You hit a bomb! Your score: \(score)")
        }
        
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.bgBlue)
        .onAppear{
            makeField(bombs)
        }
    }
    
    func makeField(_ numBomb: Int){
        score = 0
        field = Array(repeating: Array(repeating: Cell(isOpen: false, hasBomb: false), count: 5), count: 5)
        
        for _ in 0..<numBomb{
            makeBomb()
        }
        print("\n \(field) \n")
    }
    
    func makeBomb() {
        let i = Int.random(in: 0..<field.count)
        let j = Int.random(in: 0..<field[i].count)
        if field[i][j].hasBomb == false {
            field[i][j].hasBomb = true
        }
        else{
            makeBomb()
        }
    }
}

#Preview {
    ContentView()
}




struct Cell{
    var isOpen: Bool
    var hasBomb: Bool
}


/*
 I.
 1) Координаты бомб
 2) Поле с нажатыми кнопками
 */


