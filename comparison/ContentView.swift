//
//  ContentView.swift
//  comparison
//
//  Created by Kato Taiki on 2023/03/04.
//

import SwiftUI

struct Target: Identifiable{
    var id: Int
    var name: String
}

struct Eval: Identifiable{
    var id = UUID()
    var name: String
    var value: Int
    
    mutating func set_value(new_value: Int){
        value = new_value
    }
}

class SingletonClass: ObservableObject{
    static var shared = SingletonClass()
    @Published var target_list:[Target] = []
    @Published var eval_list:[Eval] = []
    
    func add_target(target: String){
        target_list.append(Target(id:target_list.count+1, name:target))
    }
}

struct EvalView: View{
    @State var test_eval:[Eval] = [Eval(name:"軸1", value:1)]
    var selection_list:[Int] = [1, 2, 3, 4, 5]
    var body: some View{
        NavigationView{
            VStack{
                HStack{
                    Text("評価軸").padding(50)
                    Text("評価").padding(50)
                }
                ForEach(test_eval){row in
                    HStack{
                        Text(row.name)
                        ForEach(selection_list, id:\.self){radio in
                            Image(systemName: row.value == radio ? "checkmark.circle.fill" : "circle").foregroundColor(.blue).onTapGesture {
                                test_eval[0].value = radio
                            }
                        }
                    }.frame(height: 40)
                }
            }
        }
    }
}
    
    
    
struct HomeView: View{
    @ObservedObject private var singletonClass = SingletonClass.shared
    var body: some View{
        NavigationView{
            VStack{
                List(singletonClass.target_list){target in
                    NavigationLink(destination: EvalView()){
                        Text(target.name)
                    }
                }
                NavigationLink(destination: AddView()){
                    Text("対象を追加")
                }.navigationTitle("target list")
            }
        }
    }
}
    
struct AddView: View{
    @State private var target = ""
    var body: some View{
        VStack {
            Text("評価対象の追加")
            TextField("評価対象を入力", text: $target).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                SingletonClass.shared.add_target(target: target)
            }){
                Text("追加")
            }
        }.padding()
    }
}
    
struct ContentView: View{
    var body: some View {
        HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
