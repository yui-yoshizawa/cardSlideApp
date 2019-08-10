//
//  LikedListTableViewController.swift
//  cardSlideApp
//
//  Created by 吉澤優衣 on 2019/08/10.
//  Copyright © 2019 吉澤優衣. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {
    
    // いいねされた名前の一覧
    var likedName: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 必須: セルの数を返すメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // いいねされたユーザーの数
        return likedName.count
    }

    // 必須: セルの設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // いいねされた名前を表示
        cell.textLabel?.text = likedName[indexPath.row]

        return cell
    }
    
    
    }
