//
//  SelectMovieViewController.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class SelectMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, MovieDisplayCellDelegate {

    @IBOutlet weak var displayTheatrersTableView: UITableView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var moveiNameLabel: UILabel!
    @IBOutlet weak var displayDatesCollectionView: UICollectionView!
    var dates: [Date]! = []
    var timeZone = TimeZone.current
    var components: DateComponents! {
        didSet {
            components.timeZone = timeZone
        }
    }
    var calendar: Calendar = .current
    var selectedDate = Date()
    var minimumDate = Date()
    var maximumDate: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
    }
    public var highlightColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1)
    public var darkColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 1)
    public var daysBackgroundColor = UIColor(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1)
    
    var theaterName: String?
    var collectionViewShowTiming: String?
    var event:Event?
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTheatrersTableView.delegate = self
        displayTheatrersTableView.dataSource = self
        getTheaters()
        renderMovieView()
        
        displayDatesCollectionView.delegate = self
        displayDatesCollectionView.dataSource = self
        fillDates(fromDate: minimumDate, toDate: maximumDate)
        updateCollectionView(to: self.selectedDate)
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)

//        movieImageView.alpha = 0.4
        
  //       displayTheatrersTableView.rowHeight = UITableViewAutomaticDimension
 //      displayTheatrersTableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
        //TODO
        moveiNameLabel.isHidden = true
    }

    func getTheaters() {
    
    MovieDB.sharedInstance.getCinemas(completionHandler: { (theaters) in
            var count = 0
            var theaterArray = [Theater]()

                for theater in theaters  {
                    if(count < 7) {
                        var tDictionary = [String:Any]()
                        tDictionary["name"] = theater["name"]
                        let loc = tDictionary["location"] as? [String:Any]
                        let addr = loc?["address"] as? [String:Any]
                        let addrText = addr?["display_text"]
                        tDictionary["location"] = addrText
                        tDictionary["showtimes"] = ["10:00 AM","1:00 PM", "3:00 PM","6:30 PM"]
                        let theater = Theater(dictionary: tDictionary)
                        theaterArray.append(theater!)
                    }
                    count = count + 1
                }
            self.event?.theaters = theaterArray
            self.displayTheatrersTableView.reloadData()
            })
    }
    
    
    func renderMovieView() {
        moveiNameLabel.text = event?.name
        self.navigationItem.title = event?.name

        if let imgUrl = event?.image {
            var imageUrl = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
            if(event?.category != "movies") {
                imageUrl = imgUrl
            }
            let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imageUrl)!)
            movieImageView.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                if res != nil {
                    self.movieImageView.alpha = 1
                    self.movieImageView.image = result
                    UIView.animate(withDuration: 3.0, animations: { () -> Void in
                        self.movieImageView.alpha = 0.8
                    })
                }else{
                    self.movieImageView.image = result
                    self.movieImageView.alpha = 0.8
                }
            }, failure: {(req, res, result) -> Void in
                
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (event?.theaters!.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = displayTheatrersTableView.dequeueReusableCell(withIdentifier: "MovieDisplayCell", for: indexPath) as! MovieDisplayCell
        for showtime in (event?.theaters?[indexPath.section].showtimes)! {
            cell.showTimings.append(showtime)
        }
        cell.delegate = self
        cell.sectionNum = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (event?.theaters?[section].name)! //+ "\n" + (event?.theaters?[section].location)!)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.backgroundColor = UIColor.black
//        label.textColor = UIColor.white
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.text = (event?.theaters?[section].name)! //+ "\n" + (event?.theaters?[section].location)!
//        return label
//    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // constants, should be initialized somewhere else
        let totalItem: CGFloat = 12
        let totalCellInARow: CGFloat = 4
        let cellHeight: CGFloat = 120
        let itemHeight: CGFloat = 26
        let collViewTopOffset: CGFloat = 10
        let collViewBottomOffset: CGFloat = 10
        
        let minLineSpacing: CGFloat = 5
        
        // calculations
        let totalRow = ceil(totalItem / totalCellInARow)
        let totalTopBottomOffset = collViewTopOffset + collViewBottomOffset
        let totalSpacing = CGFloat(totalRow - 1) * minLineSpacing   // total line space in UICollectionView is (totalRow - 1)
        let totalHeight  = (itemHeight * totalRow) + totalTopBottomOffset + totalSpacing + 20
        
        return totalHeight 
    } */
    
    //DateCollection
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DatePickerCollectionViewCell
        
        let date = dates[indexPath.item]
        cell.populateItem(date: date, highlightColor: highlightColor, darkColor: darkColor)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //workaround to center to every cell including ones near margins
        if let cell = collectionView.cellForItem(at: indexPath) {
            let offset = CGPoint(x: cell.center.x - collectionView.frame.width / 2, y: 0)
            collectionView.setContentOffset(offset, animated: true)
        }
        
        // update selected dates
        let date = dates[indexPath.item]
        let dayComponent = calendar.dateComponents([.day, .month, .year], from: date)
        components.day = dayComponent.day
        components.month = dayComponent.month
        components.year = dayComponent.year
        if let selected = calendar.date(from: components) {
            if selected.compare(minimumDate) == .orderedAscending {
                selectedDate = minimumDate
                print(selectedDate)
                //resetTime()
            } else {
                selectedDate = selected
                print(selectedDate)
            }
        }
    }
    
    func resetTime() {
        components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: selectedDate)
        updateCollectionView(to: selectedDate)
    }
    
    func updateCollectionView(to currentDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        for i in 0..<dates.count {
            let date = dates[i]
            if formatter.string(from: date) == formatter.string(from: currentDate) {
                let indexPath = IndexPath(row: i, section: 0)
                displayDatesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.displayDatesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                })
                
                break
            }
        }
    }
    func fillDates(fromDate: Date, toDate: Date) {
        
        var dates: [Date] = []
        var days = DateComponents()
        
        var dayCount = 0
        repeat {
            days.day = dayCount
            dayCount += 1
            guard let date = calendar.date(byAdding: days, to: fromDate) else {
                break;
            }
            if date.compare(toDate) == .orderedDescending {
                break
            }
            dates.append(date)
        } while (true)
        
        self.dates = dates
        self.displayDatesCollectionView.reloadData()
        
        if let index = self.dates.index(of: selectedDate) {
            self.displayDatesCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func MovieDisplayCellDelegate(str: String, tableSectionNum: Int) {
        collectionViewShowTiming = str
        theaterName = event?.theaters?[tableSectionNum].name
        print(theaterName)
        performSegue(withIdentifier: "fromSelectMovieToCreateEvent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CreateEventViewController
        vc.event = self.event
        vc.showTime = self.collectionViewShowTiming
        vc.movieSelectedDate = self.selectedDate
        vc.theaterName = self.theaterName
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
