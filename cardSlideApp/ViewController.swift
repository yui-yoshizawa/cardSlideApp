//
//  ViewController.swift
//  cardSlideApp
//
//  Created by 吉澤優衣 on 2019/08/10.
//  Copyright © 2019 吉澤優衣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    
    // スワイプ中に good or bad の表示
    @IBOutlet weak var likeImage: UIImageView!
    
    // ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!
    
    
    // ベースカードの中心
    var centerOfCard :CGPoint!    // カードがある以上CGPointはあるから、!つけても nil は入らない。(0,0)は左上。
    
    // ユーザーカードの配列
    var personList: [UIView] = []
    
    // 選択されたカードの数
    var selectedCardCount :Int = 0
    
    // ユーザーリスト
    let nameList : [String] = ["津田梅子", "ジョージ・ワシントン", "ガリレオガリレイ", "板垣退助", "ジョン万次郎"]
    
    // 「いいね」をされた名前の配列
    var likedName: [String] = []
    
    
    // view のレイアウト処理が完了した時に呼ばれる。補足資料ライフサイクルの仲間。
    // レイアウトの処理は、とりま viewDidLayoutSubviews に突っ込む！
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center    // xyの情報が、.center で取れる。
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as!
                LikedListTableViewController
            
            vc.likedName = likedName
        }
    }
    
    
    // 【ベースカードを元に戻す】
    func resetCard() {
        // 位置を戻す
        baseCard.center = centerOfCard    // ベースカードはどこで指を離そうが元の位置に戻す必要がある。
        // 角度を戻す
        baseCard.transform = .identity    // .identity で元に戻る
    }
    
    
    

    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        
        // 【ベースカードを動かす】
        // ベースカードを取得
        let card = sender.view!
        
        // 動いた距離を取得
        let point = sender.translation(in: view)    // 大元のviewからどのくらい動いたか
        
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)    //  カードの中心に、動いた距離のxy座標をプラス
        
        // 【津田梅子たちにベースカードと同じ動きをさせる】
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)    // 津田梅子たちの中心から動いた距離のxy座標をプラス
        
        // 【角度をつける】
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x    // 移動した先のx座標から元のx座標を引く
        
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)    // ★xfromCenterは画面最端= 1、(view.frame.width / 2)は画面の横半分。
        
        // ユーザーカードにも角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        
        
        if xfromCenter > 0 {
            // goodを表示
            likeImage.image = #imageLiteral(resourceName: "いいね")    // ← imageLiteral でやった。colorLiteral とかもあるらしい。
            // 上で格納したimageを表示
            likeImage.isHidden = false
            
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }
        
        
        if sender.state == UIGestureRecognizer.State.ended {
            // 離した時点のカードの中心の位置が左から50以内のとき
            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 該当のユーザーカードを画面外(マイナス方向)へ飛ばす
                    self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x - 500, y: self.personList[self.selectedCardCount].center.y)
                    // ベースカードを元に戻す処理
                    self.resetCard()
                    
                })
                // likeImageを隠す
                likeImage.isHidden = true
                // 次のカードへ
                selectedCardCount += 1
                // 画面遷移
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                // 離した時点のカードの中心の位置が右から50以内のとき
            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 該当のユーザーカードを画面外(プラス方向)へ飛ばす
                    self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x + 500, y: self.personList[self.selectedCardCount].center.y)
                    // ベースカードを元に戻す処理
                    self.resetCard()
                })
                // likeImageを隠す
                likeImage.isHidden = true
                // いいねされたリストに追加
                likedName.append(nameList[selectedCardCount])
                // 次のカードへ
                selectedCardCount += 1
                // 画面遷移
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                
            } else {
                // それ以外は元の位置に戻す
                UIView.animate(withDuration: 0.5, animations: {
                    // ベースカードを元に戻す処理
                    self.resetCard()
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                })
                // likeImageを隠す
                likeImage.isHidden = true
            }
        
        
        
        
//        // 【どっか行かないようにする処理】元の位置に戻す
//        if sender.state == UIGestureRecognizer.State.ended {    // .ended は指を離した時
//
//            // 【カードを画面外に飛ばす処理】
//            if card.center.x < 50 {
//                // 【左に大きくスワイプしたときの処理】
//                UIView.animate(withDuration: 0.5, animations: {
//                    // 左へ飛ばす場合
//                    // X座標を左に500とばす(-500)
//                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)    // 横に500飛ばせば画面から消える（あまり良い処理ではないらしい）
//
//
//                })
//                // ベースカードを元に戻す
//                resetCard()
//                // likeImage を隠す
//                likeImage.isHidden = true
//                // 次のカードへ
//                selectedCardCount += 1    // これ書く場所大事！ 上に書くと最初からガリレオでてくる等おかしくなる
//
//                if selectedCardCount >= personList.count {
//                        performSegue(withIdentifier: "ToLikedList", sender: self)
//                    }
//                }
//
//            } else if card.center.x > self.view.frame.width - 50 {    // self.view.frame.width は画面の横幅いっぱい
//                // 【右に大きくスワイプしたときの処理】
//                 UIView.animate(withDuration: 0.5, animations: {
//                // 右へ飛ばす場合
//                // X座標を右に500とばす(+500)
//                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)
//                 })
//                // ベースカードを元に戻す
//                resetCard()
//                // likeImage を隠す
//                likeImage.isHidden = true
//                // いいねリストに追加
//                likedName.append(nameList[selectedCardCount])    // selectedCardCount += 1 よりも前に書く！ 次の人の名前が入っちゃうから。
//                // 次のカードへ
//                selectedCardCount += 1
//                if selectedCardCount >= personList.count {
//                performSegue(withIdentifier: "ToLikedList", sender: self)
//            }
//
//
//
//            } else {
//                // 【sender.state が指を離した状態と一緒だったら】（つまりカードを飛ばさない場合の処理）
//                // クロージャによるアニメーションの追加（梅子がマッハで戻ってくるのをいい感じにするため）
//                UIView.animate(withDuration: 0.5, animations: {
//                    // ユーザーカードを元の位置に戻す
//                    self.personList[self.selectedCardCount].center = self.centerOfCard    // 上と同様に self が必要。
//
//                    // ユーザーカードの角度を戻す
//                    self.personList[self.selectedCardCount].transform = .identity
//
//                    // ベースカードを元に戻す
//                    self.resetCard()    // クロージャの中は独立しているから？ self が必要になる。
//                    // likeImage を隠す
//                    self.likeImage.isHidden = true
//                })
//
//            }
//
//
        
            
            
            
            
    }
}

}
