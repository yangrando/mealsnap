//
//  ImageRecognitionService.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import UIKit
import CoreML
import Vision

enum ImageRecognitionError: Error {
    case modelLoadingFailed
    case imageProcessingFailed
    case recognitionFailed
}


final class ImageRecognitionService {
    
    
    private static let coreMLModel: VNCoreMLModel = {
        do {
            
            let model = try MobileNetV2(configuration: MLModelConfiguration()).model
            return try VNCoreMLModel(for: model)
        } catch {
            fatalError("Error to load model ML: \(error)")
        }
    }()
    
    func recognizeFood(in image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
            guard let pixelBuffer = image.toPixelBuffer(size: CGSize(width: 224, height: 224)) else {
                completion(.failure(ImageRecognitionError.imageProcessingFailed))
                return
            }

            let request = VNCoreMLRequest(model: ImageRecognitionService.coreMLModel) { (request, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let results = request.results as? [VNClassificationObservation] else {
                    completion(.failure(ImageRecognitionError.recognitionFailed))
                    return
                }

                let topResults = results
                    .filter { $0.confidence > 0.05 }
                    .map { $0.identifier }
                
                completion(.success(topResults))
            }

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
                } catch {
                    completion(.failure(error))
                }
            }
        }
}
