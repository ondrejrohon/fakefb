//
//  FeedDataSource.swift
//  fakefb
//
//  Created by Claude on 19/09/2025.
//

import UIKit

class FeedDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    var videoManager: VideoManager?
    private var posts: [PostModel] = []
    
    override init() {
        super.init()
        generateMockData()
    }
    
    private func generateMockData() {
        // CT24 Post
        let ct24Comments = [
            CommentModel(id: "c1", author: "Jana Nováková", avatar: "/placeholder.png", content: "Konečně! Doufám, že se dočkáme spravedlnosti.", timeAgo: "pred hodinou", likes: 5),
            CommentModel(id: "c2", author: "Peter Kováč", avatar: "/placeholder.png", content: "Sedm měsíců je dlouhá doba, ale důležité je, že se něco děje.", timeAgo: "pred 45 minútami", likes: 2),
            CommentModel(id: "c3", author: "Maria Svobodová", avatar: "/placeholder.png", content: "Myslím na rodinu obětí. Musí to být pro ně velmi těžké.", timeAgo: "pred 30 minútami", likes: 8)
        ]
        
        let ct24Post = PostModel(
            id: "post_1",
            type: .image,
            username: "CT24",
            timeAgo: "pred 2 hodinami",
            content: "Policie zatkla podezřelé z vraždy Jána Kuciaka a Martiny Kušnírové\n\nSedm měsíců po vraždě mají vyšetřovatelé pravděpodobně nájemného vraha nebo vrahy novináře a jeho přítelkyně.",
            image: createPlaceholderImage(width: 300, height: 200, text: "CT24 News"),
            likes: 23,
            comments: 7,
            shares: 2,
            commentList: ct24Comments
        )
        
        // Milan Lučanský Post
        let lucanskyComments = [
            CommentModel(id: "c4", author: "Radoslav Jesenský", avatar: "https://i.pravatar.cc/150?img=11", content: "TIEŽ ICH HNEĎ PUSTIA AKO TALIANOV?! Čakajte, že za týždeň budú voľní...", timeAgo: "pred 3 hodinami", likes: 12),
            CommentModel(id: "c5", author: "Zuzana Gašparíková", avatar: "https://i.pravatar.cc/150?img=20", content: "NEMAJÚ OBJEDNÁVATEĽA - NEMAJÚ NIČ.", timeAgo: "pred 15 minútami", likes: 4),
            CommentModel(id: "c6", author: "Alojz Kubranský", avatar: "https://i.pravatar.cc/150?img=12", content: "KONECNE!!! ale bez objednávateľa je to len divadlo", timeAgo: "pred 15 minútami", likes: 4)
        ]
        
        let lucanskyPost = PostModel(
            id: "post_2",
            type: .text,
            username: "Milan Lučanský",
            timeAgo: "pred 4 hodinami",
            content: "VEĽKÝ ÚSPECH MOJICH KOLEGOV 🇸🇰\n\nDnes môžem s hrdosťou oznámiť, že vďaka neúnavnej práci vyšetrovateľov NAKA sa podarilo zadržať podozrivých z vraždy Jána Kuciaka a Martiny Kušnírovej. Po siedmich mesiacoch intenzívnej práce prinášame prvé výsledky. Chcem sa poďakovať všetkým príslušníkom, ktorí na prípade pracovali dňom i nocou. Stále však platí, že vyšetrovanie pokračuje a nepoľavíme, kým nebude spravodlivosti učinené zadosť. Na detaily si musíme počkať, aby sme neohrozili priebeh vyšetrovania.",
            likes: 23,
            comments: 7,
            shares: 2,
            commentList: lucanskyComments
        )
        
        // Peter Pellegrini Post
        let pellegriniComments = [
            CommentModel(id: "c7", author: "Eva Horváthová", avatar: "/placeholder.png", content: "Dúfam, že sa podarí odhaliť všetkých zodpovedných.", timeAgo: "pred 3 hodinami", likes: 6),
            CommentModel(id: "c8", author: "Martin Kováč", avatar: "/placeholder.png", content: "Je dôležité, aby sa spravodlivosť dočkala.", timeAgo: "pred 2 hodinami", likes: 3)
        ]
        
        let pellegriniPost = PostModel(
            id: "post_3",
            type: .text,
            username: "Peter Pellegrini",
            timeAgo: "pred 4 hodinami",
            content: "S potešením som prijal správu o tom, že polícia zatkla podozrivých z vraždy dvoch nevinných mladých ľudí. Zároveň oceňujem profesionálnu prácu vyšetrovateľov a prokuratúry. Vyšetrenie a potrestanie vinníkov tejto vraždy je jednou z priorít mojej vlády a som veľmi rád, že policajné orgány už reálne konajú. Verím, že sa tento brutálny skutok podarí objasniť a odhaliť jeho motív ako aj objednávateľov, aby prestal rozdeľovať našu spoločnosť.",
            likes: 23,
            comments: 7,
            shares: 2,
            commentList: pellegriniComments
        )
        
        posts = [ct24Post, lucanskyPost, pellegriniPost]
    }
    
    private func createPlaceholderImage(width: Int, height: Int, text: String) -> UIImage {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()!
        
        let colors = [UIColor.systemBlue, UIColor.systemGreen, UIColor.systemOrange, UIColor.systemPurple, UIColor.systemRed]
        let color = colors.randomElement() ?? UIColor.systemBlue
        
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    private func createMockVideoURL(index: Int) -> URL? {
        return Bundle.main.url(forResource: "frame_counter_9_16", withExtension: "mp4")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        switch post.type {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextPostCell.identifier, for: indexPath) as! TextPostCell
            cell.configure(with: post)
            return cell
            
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagePostCell.identifier, for: indexPath) as! ImagePostCell
            cell.configure(with: post)
            return cell
            
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoPostCell.identifier, for: indexPath) as! VideoPostCell
            cell.videoManager = videoManager
            cell.configure(with: post)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let post = posts[indexPath.row]
            
            if post.type == .video, let videoURL = post.videoURL {
                videoManager?.preloadVideo(url: videoURL)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}