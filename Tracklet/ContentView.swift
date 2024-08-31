//
//  ContentView.swift
//  Tracklet
//
//  Created by Haddad Hannan SRG on 29/08/24.
//

import SwiftUI
import SwiftUICharts

struct ContentView : View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        
        if currentPage > totalPages {
            Home()
        }else {
            OnboardingScreen()
        }
    }
}

//MARK: Home Screen
struct Home: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    //MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    //MARK: Chart
                    let data = transactionListVM.accumulateTransactions()
                    
                    if !data.isEmpty {
                        let totalExpenses = data.last?.1 ?? 0
                        
                        CardView {
                            VStack(alignment: .leading) {
                                ChartLabel(totalExpenses.formatted(.currency(code: "IDR")), type: .title, format: "$&.02f")
                                LineChart()
                            }
                                .background(Color.systemBackground)
                        }
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                        .frame(height: 250)
                    }
                    
                    //MARK: Transaction List
                    RecentTransactionList()         
                }
                .padding()
                .frame(maxWidth: .infinity)
                
            }
            .background(Color.Background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //MARK: Notifications Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .renderingMode(.template)
                        .foregroundStyle(Color.Icon, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.black) //Not Working ahhh I must research again!
    }
}

var totalPages = 3

//MARK: OnBoardingScreens
struct OnboardingScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack {
            
            if currentPage == 1 {
                ScreenView(image: "1", title: "Tracklet Your Transactions", details: "You can record every transaction made through the Tracklet App and you can group them into relevant categories, so you can clearly see where your money is going.")
            }
            
            if currentPage == 2 {
                ScreenView(image: "2", title: "Neatly Kept Records", details: "Tracklet ensures that all your transaction records are neatly stored and easily accessible. We prioritize order and ease of navigation to provide a better financial management experience.")
            }
            
            if currentPage == 3 {
                ScreenView(image: "3", title: "Data Displayed in Charts", details: "Tracklet presents your financial data in the form of clear and easy-to-understand graphs. This visualization helps you understand spending and income patterns more quickly and effectively.")
            }
        }
    }
}

struct ScreenView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var image: String
    var title: String
    var details: String
    
//    @Binding var currentPage: Int
    
    var body: some View {
        VStack {
            HStack {
                
                if currentPage == 1 {
                    Text("Hi there, ")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4) +
                    Text("Trackies!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                        .foregroundColor(.icon)
                }else {
                    Button(action: {
                        currentPage -= 1
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(Color.black)
                            .opacity(0.4)
                            .cornerRadius(50)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    currentPage = 4
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }.padding()
                .foregroundColor(Color.Text)
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 16)
                .frame(height: 300)
            
            Spacer(minLength: 80)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .kerning(1.2)
                .padding(.top)
                .padding(.bottom, 5)
                .foregroundColor(Color.icon)
            
            Text(details)
                .opacity(0.5)
                .kerning(1.0)
                .padding([.leading, .trailing])
                .multilineTextAlignment(.center)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            HStack {
                
                if currentPage == 1 {
                    Color(.icon).frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                } else if currentPage == 2 {
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color(.icon).frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                } else if currentPage == 3{
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color(.icon).frame(height: 8 / UIScreen.main.scale)
                }
            }
            .padding(.horizontal, 35)
            
            Button(action: {
                if currentPage <= totalPages {
                    currentPage += 1
                }else {
                    currentPage = 1
                }
            }, label: {
                
                if currentPage == 3 {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.icon)
                        .cornerRadius(40)
                        .padding(.horizontal)
                }else {
                    Text("Next")
                        .fontWeight(.semibold)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.icon)
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionsListVM = TransactionListViewModel()
        transactionsListVM.transactions = transactionListPreviewData
        return transactionsListVM
    }()
    
    static var previews: some View {
            ContentView()
            .environmentObject(transactionListVM)
    }
}

