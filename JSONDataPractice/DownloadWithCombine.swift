//
//  DownloadWithCombine.swift
//  JSONDataPractice
//
//  Created by Vivek Pattanaik on 6/17/21.
//

import SwiftUI
import Combine

struct PostModel : Identifiable, Codable {
    let userId : Int
    let id : Int
    let title : String
    let body : String
}

class DownloadWithCombineViewModel : ObservableObject {
    @Published var posts : [PostModel] = []
    var cancellables = Set<AnyCancellable>()
    init () {
        getPost()
    }
    
    func getPost() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        
        // How combine works
        /*
        // 1. sign up for monthly subscription package
        // 2. company would make package bts
        // 3. ship the package and recieve at front door
        // 4. check box and see if not damaged
        // 5. open and make sure items are correct
        // 6. if item good use it
        // 7. cancellable at any time
        
        // 1. Create the publisher
        // 2. Subscribe publisher to background thread
        // 3. Recieve on main thread.
        // 4. trymap ( check if data good )
        // 5. Decode data into postmodel
        // 6. sink ( put the item in our app )
        // 7. store : cancel subscription
        */
        URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background)) // by default task publisher is in background the .subscribe is for the sake of it
            .receive(on: DispatchQueue.main)

            .tryMap(handleOutput)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .sink { (completion) in
//                print("completion : \(completion)")
            } receiveValue: { [weak self] (returnedPosts) in
                self?.posts = returnedPosts
            }
            .store(in: &cancellables)

        
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}

struct DownloadWithCombine: View {
   
    @StateObject var vm = DownloadWithCombineViewModel()
    var body: some View {
        List{
            ForEach(vm.posts) { posts in
                VStack(alignment : .leading){
                    Text(posts.title)
                        .font(.headline)
                    Text(posts.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DownloadWithCombine_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithCombine()
    }
}
