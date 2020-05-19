//
//  ActionViewController.swift
//  ActionEx
//
//  Created by 정기웅 on 2020/05/18.
//  Copyright © 2020 정기웅. All rights reserved.
//

import UIKit
import MobileCoreServices
import SwiftSoup

class ActionViewController: UIViewController {

    
    @IBOutlet weak var myTextView: UITextView!
    
    // Containing App의 설정 정보
    private var setInfo = Dictionary<String, Bool>()
    private var imageURLs = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Containing App 에서 setInfo 을 받아온다.
        setInfo = getSetInfoFromContainingApp()
        
        // 1. Hosting App 에서 HTML 을 받아온다.
        // 2. <img src="---"> 을 파싱한다.
        preprocessHTML()
        
        
        
        
        //- ToDo
        /*
         
         1. Parsing by referring to the set info
         2. ActionViewController 에 parsing한 img 띄우기
         3. 골라서 사진 저장
         
         4. action extension activation on only safari(browsers)
         
         - 비동기 끝날 때까지 activity indicator
         */
        
        
        
        
    }
    
    
    
    
    private func getSetInfoFromContainingApp() -> Dictionary<String, Bool> {
        
        // containing app 과 데이터 공유하기
        let shareDefaults = UserDefaults(suiteName: "group.reqGroup")
        guard let sharedInfo = shareDefaults!.dictionary(forKey: "setting") as? Dictionary<String, Bool> else {
            print("Error[ getSetInfoFromContainingApp ] : Failed to get Set Info.")
            return Dictionary<String,Bool>()
        }
        
        print("[ getSetInfoFromContainingApp ] : Succeeded to get Set Info.")
        print("-- Set Info --------------------------------------------")
        print(sharedInfo)
        print("--------------------------------------------------------")
        
        return sharedInfo
    }
    
    
    private func preprocessHTML() {
        
        // 모든 익스텐션 뷰 컨트롤러는 ExtensionContext 클래스의 인스턴스 형태로 연결된 익스텐션 콘텍스트를 갖는다.
        // 익스텐션 콘텍스트는 객체를 포함하고 있는 배열의 형태인 inputItems라는 이름의 속성을 가지고 있다.
        // 첫 번째 입력 아이템 객체에 대한 참조체를 얻는다.
        let extensionItem: NSExtensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        
        // NSExtensionItem 객체는 attachment 객체들의 배열을 갖는다.
        // attachment 객체는 NSItemProvider 타입으로 캐스팅하여 호스트 앱의 데이터에 접근할 수 있다.
        let itemProvider = extensionItem.attachments![0]
        
        // Action Extension 이 지원하는 타입의 데이터를, 호스트 앱이 가지고 있는지 검증 (URL Type: kUTTypeURL or "public.url")
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
            
            // Hosting App 에서 데이터를 비동기로 받아옴. Completion Handler 을 이용해 데이터 처리.
            itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (url: NSSecureCoding!, error: Error!) in
                
                //NSSecureCoding 에서 사용가능한 타입(URL)으로 캐스팅한다.
                guard let url: URL = url as? URL else {
                    print("Error[ preprocessHTML ] : \(error.debugDescription))")
                    return
                }
                
                do {
                    // 해당 URL에 HTML소스파일을 요청한다.
                    let HTML: String = try String(contentsOf: url)
                    
                    // <img src> 태그를 파싱한다.
                    do {
                        let doc: Document = try SwiftSoup.parse(HTML)
                        let srcs: Elements = try doc.select("img[src]")
                        self.imageURLs = srcs.array().map { try! $0.attr("src").description }
                        
                        DispatchQueue.main.async {   // <---- 이거 할 줄 몰라서 8시간 헤맴 / 이제 롤하러가야지
                            
                            //
                            // 대충 데이터 tableview에 올리는 구간
                            // 1. 테이블 뷰에 직접 넣거나
                            // 2. or, imageURLs 프로퍼티에 넣고 reloadData하거나
                            
                            //self.myTextView.text += a
                            
                        }
                        
                    }
                    catch Exception.Error(_, let message) {
                        print(message)
                    }
                    catch {
                        print("error")
                    }
                }
                catch let error {
                    print("Error[ preprocessHTML ] : Request to get HTML file is denied.")
                    print(error)
                    print("--------------------------------------------------------")
                }
            }
        }
        
        
    }
    
    
    @IBAction func done() {
        /*
           // 수정된 콘텐츠와, 콘텐츠 타입으로 새로운 NSItemProvider 인스턴스를 만든다.
           let returnProvider = NSItemProvider(item: HTMLSource as NSSecureCoding, typeIdentifier: kUTTypeText as String)
        
           // NSExtensionItem 인스턴스를 생성한다.
           let returnItem = NSExtensionItem()
           // NSItemProvider 객체를 attachments에 할당.
           returnItem.attachments = [returnProvider]
           // returningItems 인자로 NSExtensionItem 인스턴스를 전달하며 호출
           self.extensionContext!.completeRequest(returningItems: [returnItem], completionHandler: nil)
         */
    }

}
