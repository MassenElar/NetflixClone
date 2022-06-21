//
//  YoutubeModelView.swift
//  NetflixClone
//
//  Created by developer on 6/20/22.
//

import Foundation
import UIKit


struct ShowDetails {
    
    
    typealias YTBResult = Result<[Video], NetworkError>
    
    
    func getShowDetails(with model: ShowViewModel, viewController: UIViewController) {
        let title = model.title
        let youtubeReq = YoutubeRequest()
       
        youtubeReq.getYoutubeResult(with: title) {  result in
            self.handleResult(result: result, show: model, viewController: viewController)
        }
        
    }
    
    
    func handleResult(result: YTBResult, show: ShowViewModel, viewController: UIViewController) {
        switch result{
        case .success(let video):
            DispatchQueue.main.async { 
                let viewModel = VideoPrevViewModel(title: show.title, youtubeView: video[0], showOverview: show.overView )
                let vc = ShowPrevViewController()
                vc.configure(with: viewModel)
                viewController.navigationController?.pushViewController(vc, animated: true)
            }
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
}
