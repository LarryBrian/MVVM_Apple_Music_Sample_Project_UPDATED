//
//  ViewController.swift
//  AppleMusicSampleProject
//
//  Created by Brian King on 5/16/21.
//

import UIKit
class AlbumsViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var albumsTableView: UITableView!
    
    // MARK: - VARIABLES
    let viewModel = AlbumsViewModel()
    let activityIndicator = ActivityIndicatorViewController()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegatesAndDatasources()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createActivityIndicator()
        fetchAlbums()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumDetailsVC" {
            let detailsVC = segue.destination as! AlbumDetailViewController
            detailsVC.album = viewModel.selectedAlbum
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setDelegatesAndDatasources() {
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
    }
    
    private func fetchAlbums()  {
        Task {
            do {
                try await viewModel.fetchTopAlbumsData()
                updateTableViewData()
            } catch {
                presentFetchAlbumFailedAlert()
                print(error)
            }
        }
    }
    
    @MainActor private func updateTableViewData() {
        albumsTableView.reloadData()
        activityIndicator.willMove(toParent: nil)
        activityIndicator.view.removeFromSuperview()
        activityIndicator.removeFromParent()
    }
    
    @MainActor private func presentFetchAlbumFailedAlert() {
        let alert = UIAlertController.init(title: "Oops!", message: "There was a problem loading the top albums from Apple Music.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    private func createActivityIndicator() {
        addChild(activityIndicator)
        activityIndicator.view.frame = view.frame
        view.addSubview(activityIndicator.view)
        activityIndicator.didMove(toParent: self)
    }
}

// MARK: - EXTENSIONS
extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
        
        cell.album = viewModel.albums[indexPath.row]
        
        return cell
    }
}

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedAlbum = viewModel.albums[indexPath.row]
        performSegue(withIdentifier: "showAlbumDetailsVC", sender: self)
    }
}

