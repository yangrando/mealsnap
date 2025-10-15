//
//  HistoryView.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 06/10/25.
//

import SwiftUI
import CoreData

struct HistoryView: View {
        
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.timestamp, ascending: false)],
        animation: .default)
    private var meals: FetchedResults<Meal>
    
    
    var body: some View {
        NavigationView{
            if meals.isEmpty {
                VStack {
                       Image(systemName: "fork.knife.circle")
                           .font(.system(size: 60))
                           .foregroundColor(.gray)
                       Text("history_empty_state_message")
                           .font(.title2)
                           .foregroundColor(.gray)
                           .multilineTextAlignment(.center)
                           .padding()
                   }
                   .navigationTitle("history_view_title")
            } else {
                List {
                    ForEach(meals) { meal in
                        HistoryRowView(meal: meal)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(Text("history_view_title"))
            }
        }
    }
}

struct HistoryRowView: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 15) {
            if let photoData = meal.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "photo")
                    .frame(width: 60, height: 60)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading) {
                Text(meal.identifiedFoods?.replacingOccurrences(of: ",", with: ", ") ?? "N/A")
                    .font(.headline)
                
                if let timestamp = meal.timestamp {
                    Text(timestamp, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
