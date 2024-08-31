//
//  ContentView.swift
//  johnson test app
//
//  Created by johnson on 31/08/24.
//

import SwiftUI
import CoreData

struct Fruit: Identifiable , Hashable {
    let id = UUID()
    let name: String
    let image: String
    let subName : String
}


struct ContentView: View {
    
    @State private var searchText: String = ""
    @State private var previousOffset: CGFloat = 0
    @State private var scrollToTop: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var isExpanded: Bool = false
    let images = [
        "Unknown", "Unknown 1", "Unknown 2"
    ]
    @State private var message: String = "Swipe up or down"
    
   // @State private var searchText: String = ""
    
    let items1 = ["Apple", "Banana", "Orange", "Pineapple", "Grapes", "Strawberry"]
    
    let fruits = [
        Fruit(name: "Apple", image: "Unknown", subName: "Red"),
        Fruit(name: "Banana", image: "Unknown 1", subName: "yellow"),
        Fruit(name: "Orange", image: "Unknown 2", subName: "Orange"),
        Fruit(name: "Grapes", image: "Unknown", subName: "blue"),
        Fruit(name: "Strawberry", image: "Unknown 1", subName: "pink")
        
    ]
    var filteredFruits: [Fruit] {
        if searchText.isEmpty {
            return fruits
        } else {
            return fruits.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    
    @State private var lastContentOffset: CGFloat = 0
    @State private var scrollDirection: ScrollDirection = .none
    
    enum ScrollDirection {
        case up
        case down
        case none
    }
    
    var body: some View {
        ScrollViewReader { proxy in
        ScrollView {
            VStack{
                if scrollToTop == false{
                    TabView {
                        ForEach(images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFit().cornerRadius(10)
                                .tag(imageName)
                        }
                    }.frame(width: UIScreen.main.bounds.width - 40)
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                //   Spacer().frame(height: 10)
                
                SearchBar(text: $searchText).frame(width: UIScreen.main.bounds.width - 40).padding(.top, -20)//.offset(y : -20)
                
                Spacer().frame(height: 10)
                
                //  Spacer()
                
                ForEach(filteredFruits, id: \.self) { item in
                    
                    HStack{
                        
                        Spacer().frame(width: 10)
                        
                        
                        Image(item.image).frame(width: 50,height: 50).cornerRadius(5)
                        
                        VStack{
                            HStack{
                                Text(item.name)
                                Spacer()
                            }
                            
                            HStack{
                                Text(item.subName)
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.width - 40,height: 65).background(Rectangle().fill(Color(red: 210/255, green: 231/255, blue: 225/255)).frame(width: UIScreen.main.bounds.width - 40,height: 65).cornerRadius(10))
                    
                    //  HStack{}.frame(height: 5)
                    
                    
                }
                
                Spacer()
                
                //                       List(filteredItems, id: \.self) { item in
                //                           Text(item)
                //                       }
                
                
                //  }
//                .background(
//                                    GeometryReader { geometry in
//                                        Color.clear
//                                            .preference(key: ScrollOffsetKey.self, value: geometry.frame(in: .global).minY)
//                                    }
//                                )
                
            }.frame(width: UIScreen.main.bounds.width ,height: UIScreen.main.bounds.height)
            
              
              
        }
            
        .gesture(
           DragGesture().onChanged { value in
              if value.translation.height > 0 {
                  scrollToTop = false
              } else {
                 print("Scroll up")
                  
                  scrollToTop = true
              }
           }
            )
//        .onPreferenceChange(ScrollOffsetKey.self) { newValue in
//                    if newValue < 10 {
//                        scrollDirection = .down
//                    } else if newValue > 10 {
//                        scrollDirection = .up
//                    } else {
//                        scrollDirection = .none
//                    }
//                    previousOffset = newValue
//                    print("Scrolling \(scrollDirection == .up ? "Up" : scrollDirection == .down ? "Down" : "None")")
//                }
//        .onChange(of: scrollToTop) { value in
//            if value {
//                withAnimation {
//                    proxy.scrollTo("searchBar", anchor: .top)
//                }
//                scrollToTop = false
//            }
//        }
    }

        HStack{
            
            Spacer()
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            
            if isExpanded {
                VStack {
                    
                    ForEach(filteredFruits, id: \.self) { item in
                        Button(action: {}) {
                            Text(item.name)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .transition(.opacity) // Animates the appearance with a scale effect
            }
            
            Spacer().frame(width: 20)
            
        }.offset(y : -50)
//        .gesture(
//            DragGesture()
//                .onEnded { value in
//                    let verticalAmount = value.translation.height
//                    
//                    if verticalAmount < 0 {
//                        // Swipe Up
//                        message = "Swiped Up"
//                    } else if verticalAmount > 0 {
//                        // Swipe Down
//                        message = "Swiped Down"
//                    }
//                }
//        )
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        
        searchBar.backgroundImage = UIImage() // Set an empty image
                searchBar.backgroundColor = .clear
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
