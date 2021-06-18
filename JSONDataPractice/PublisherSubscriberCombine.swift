//
//  PublisherSubscriberCombine.swift
//  JSONDataPractice
//
//  Created by Vivek Pattanaik on 6/17/21.
//

import SwiftUI
import Combine

class SubscriberViewModel : ObservableObject {
    @Published var count: Int = 0
    var timer : AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    @Published var textFieldText : String = ""
    @Published var textIsValid : Bool = false
    
    init() {
        setUpTimer()
    }
    
    func addTextFieldSubscriber(){
        $textFieldText
            .map { (text) -> Bool in
                if text.count > 3{
                    return true
                }
                return false
            }
            .assign(to: \.textIsValid, on: self)
            .store(in: &cancellables)
    }
    
    func setUpTimer() {
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self  = self else {return}
                self.count += 1
                
            }
            
            
            
    }
    
}

struct PublisherSubscriberCombine: View {
    
    @StateObject var vm = SubscriberViewModel()
    
    var body: some View {
        
        VStack(){
            Text("\(vm.count)")
                .font(.largeTitle)
            Text("\(vm.textIsValid.description)")
            TextField("Type Something here ....", text: $vm.textFieldText)
                .padding(.leading)
                .frame(height: 55)
                .font(.headline)
                .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                .cornerRadius(10)
        }.padding()
        
    }
    
}

struct PublisherSubscriberCombine_Previews: PreviewProvider {
    static var previews: some View {
        PublisherSubscriberCombine()
    }
}
