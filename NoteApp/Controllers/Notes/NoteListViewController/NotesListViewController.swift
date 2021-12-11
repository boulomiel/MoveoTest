//
//  NotesListViewController.swift
//  tabsandpage
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

class NotesListViewController : UIViewController, NotesStoryBoard{
    
    @IBOutlet weak var noteTableView : UITableView!
    var noteView : NoNoteView?
    var noteListViewModel : NoteListViewModel?
    lazy var notesDataHandler = NotesDataHandler(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocManager.shared.start()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteListViewModel = NoteListViewModel()
        notesDataHandler.fetchData()
        noteListViewModel?.bind(tableView: noteTableView)
    }
    
    private func showNoNoteSaved(){
        noteView =  NoNoteView(frame: CGRect(origin: CGPoint(x: 0, y: 85), size: self.view.frame.size))
        self.view.addSubview(noteView!)
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {[weak self] in
            if let noteView = self?.noteView {
                noteView.frame = CGRect(origin: CGPoint(x: 0, y: 135), size: noteView.frame.size)
            }
        }, completion: nil)
    }
    
    private func setupTableView(){
        noteTableView.delegate = self
        noteTableView.dataSource =  self
        noteTableView.register(NoteCell.self)
    }
    
    private func removeNoNotesAnimation(){
        noteView?.layer.removeAllAnimations()
        noteView?.removeFromSuperview()
    }
    
    @IBAction func toEditViewController(_ sender: Any) {
        Router.showNotesEditViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNoNotesAnimation()
        noteListViewModel = nil
    }
}

extension NotesListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  noteListViewModel?.observer.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NoteCell =  tableView.dequeueCell(indexPath: indexPath)
        cell.viewModel = noteListViewModel!.notesViewModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel  = noteListViewModel?.notesViewModel[indexPath.row]{        Router.showNotesEditViewController(noteVM: viewModel)
        }
    }
}

extension NotesListViewController : NotesDataDelegate{
    
    func dataFetched(notes: [Note]) {
        removeNoNotesAnimation()
        noteListViewModel?.observer.value =  notes
    }
    
    func noDataFetched() {
        showNoNoteSaved()
    }
}
