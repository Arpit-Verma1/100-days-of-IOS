//
//  CoinImageService.swift
//  CryptoNest
//
//  Created by arpit verma on 11/08/24.
//

import Foundation
import SwiftUI
import Combine
class CoinImageService {
    @Published var image : UIImage? = nil
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coinImages"
    private let imageName : String
    private var imageSubscription : AnyCancellable?
    
    init(coin:CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()	
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
           image = savedImage
            print("get image from folder")
        }
        else {
            downloadCoinImage()
            print("downloading image")
        }
            
        
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string:  coin.image) else { return }
       
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self,  let downloadImage = returnedImage else {return }
                self.image = downloadImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            })
           
            
            
    }
}
