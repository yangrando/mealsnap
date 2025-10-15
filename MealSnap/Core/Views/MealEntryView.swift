import SwiftUI
import Foundation
import CoreData

struct MealEntryView: View {

    @StateObject private var viewModel: MealEntryViewModel
    @State private var isShowingCamera = false
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MealEntryViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                switch viewModel.viewState {
                case .idle:
                    if let image = viewModel.capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .frame(height: 300)
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                Text("placeholder_image_title")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                            }
                        }
                    }
                    
                case .loading:
                    ZStack {
                        if let image = viewModel.capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)
                                .opacity(0.5)
                        }
                        ProgressView("analysis_loading")
                    }
                    
                case .success(let meal):
                    // Estado de sucesso: mostra imagem + resultados
                    VStack(spacing: 15) {
                        // Imagem da refeição
                        Image(uiImage: meal.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)
                        
                        // Resultados da análise
                        VStack(alignment: .leading, spacing: 15) {
                            Text("analysis_results_title")
                                .font(.headline)
                            
                            ForEach(meal.identifiedFoods, id: \.self) { item in
                                Text("• \(item.capitalized)")
                            }
                            
                            if let nutrition = meal.nutritionInfo {
                                Divider()
                                Text(String(format: NSLocalizedString("nutrition_info_title", comment: ""), meal.identifiedFoods.first?.capitalized ?? ""))
                                    .font(.headline)
                                    .padding(.top, 5)
                                
                                HStack {
                                    Text("nutrition_calories").bold()
                                    Spacer()
                                    Text(nutrition.calories)
                                }
                                HStack {
                                    Text("nutrition_carbs").bold()
                                    Spacer()
                                    Text(nutrition.carbs)
                                }
                                HStack {
                                    Text("nutrition_fat").bold()
                                    Spacer()
                                    Text(nutrition.fat)
                                }
                                HStack {
                                    Text("nutrition_protein").bold()
                                    Spacer()
                                    Text(nutrition.protein)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    
                case .saved:
                    // Estado salvo: mostra confirmação
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        Text("meal_saved_feedback")
                            .font(.title2)
                            .bold()
                    }
                    .frame(height: 300) // Mantém altura consistente
                    
                case .error(let errorMessage):
                    // Estado de erro: mostra mensagem de erro
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.1))
                            .frame(height: 300)
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                }
                
                Spacer()
                
                switch viewModel.viewState {
                case .idle, .error:
                    VStack(spacing: 15) {
                        Button(action: {
                            self.isShowingCamera = true
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text(viewModel.capturedImage == nil ? "take_photo_button" : "take_another_photo_button")
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        
                        // Botão de análise só aparece se tiver imagem
                        if viewModel.capturedImage != nil {
                            Button(action: {
                                viewModel.analyzeImage()
                            }) {
                                HStack {
                                    Image(systemName: "sparkles")
                                    Text("analyze_meal_button")
                                }
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                        }
                    }
                    
                case .loading:
                    EmptyView()
                    
                case .success:
                    VStack(spacing: 15) {
                        Button(action: {
                            self.isShowingCamera = true
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("take_another_photo_button")
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            viewModel.save()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("save_meal_button")
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                    }
                    
                case .saved:
                    Button(action: {
                        viewModel.clearAll()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("new_meal_button")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding()
            .navigationTitle(Text("meal_entry_view_title"))
            .sheet(isPresented: $isShowingCamera) {
                SafeCameraView(capturedImage: $viewModel.capturedImage)
            }
            .onChange(of: viewModel.capturedImage) { _ in
                viewModel.resetState()
            }
        }
    }
}
