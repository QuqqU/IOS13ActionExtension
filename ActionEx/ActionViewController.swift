//
//  ActionViewController.swift
//  ActionEx
//
//  Created by 정기웅 on 2020/05/18.
//  Copyright © 2020 정기웅. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    
    @IBOutlet weak var myTextView: UITextView!
    var convertedString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 모든 익스텐션 뷰 컨트롤러는 ExtensionContext 클래스의 인스턴스 형태로 연결된 익스텐션 콘텍스트를 갖는다.
        // 익스텐션 콘텍스트는 객체를 포함하고 있는 배열의 형태인 inputItems라는 이름의 속성을 가지고 있다.
        
        // 첫 번째 입력 아이템 객체에 대한 참조체를 얻는다.
        let textItem: NSExtensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        
        // NSExtensionItem 객체는 attachment 객체들의 배열을 갖는다.
        // attachment 객체는 NSItemProvider 타입으로 캐스팅하여 호스트 앱의 데이터에 접근할 수 있다.
        let textItemProvider = textItem.attachments![0]
        // 익스텐션이 지원하는 타입의 데이터를 호스트 앱이 가지고 있는지 검증하기 위한 메서드 (텍스트 타입: kUTTypeText)
        if textItemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
            // 호스트 앱의 데이터를 로딩하는것은 비동기적으로 수행되므로 완료 핸들러를 지정해야한다.
            textItemProvider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) {
                (string: NSSecureCoding!, error: Error!) in
                self.convertedString = string as? String
                       
                if self.convertedString != nil {
                    self.convertedString = self.convertedString?.uppercased()
                           
                           // 메인 앱 스레드와 다른 스레드에서 실행되기 때문에
                           // 변환 결과를 메인 스레드로 보내기 위한 메서드 (비동기)
                           DispatchQueue.main.async {
                               self.myTextView.text = self.convertedString!
                           }
                       }
            }
        }
        
        
        
        let shareDefaults = UserDefaults(suiteName: "group.reqGroup")
        let name =  shareDefaults!.object(forKey: "name") as? String

        print(name!)
    }
    

    @IBAction func done() {
           // 수정된 콘텐츠와, 콘텐츠 타입으로 새로운 NSItemProvider 인스턴스를 만든다.
           let returnProvider = NSItemProvider(item: convertedString! as NSSecureCoding, typeIdentifier: kUTTypeText as String)
        
           // NSExtensionItem 인스턴스를 생성한다.
           let returnItem = NSExtensionItem()
           // NSItemProvider 객체를 attachments에 할당.
           returnItem.attachments = [returnProvider]
           // returningItems 인자로 NSExtensionItem 인스턴스를 전달하며 호출
           self.extensionContext!.completeRequest(returningItems: [returnItem], completionHandler: nil)
    }

}
