//
//  DownloadWithEscapting.swift
//  JSONDataPractice
//
//  Created by Vivek Pattanaik on 6/17/21.
//

import SwiftUI

class DownloadWithEscapingViewModel : ObservableObject {
    
    init(){
        
    }
    
    func getPosts() {
        
        guard let url = URL(string: "") else {return}
        URLSession.shared.dataTask(with: url) { data , response , error  in
            guard let data = data else {
                print("No Data")
                return
            }
            
            guard error == nil else {
                print("Error: \(String(describing : error))")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Invalid Response.")
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Status code shourld be 2xx, but is \(response.statusCode)")
                return
            }
            
            print("SUCESSFULLY DOWNLOADED DATA")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            
            
        }.resume()
    }
}

struct DownloadWithEscapting: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct DownloadWithEscapting_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscapting()
    }
}
