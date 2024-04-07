//import UIKit
//import CoreData
//
//class FirstViewController: UIViewController {
//    
//    private let button: UIButton = {
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
//        button.setTitle("Log In", for: .normal)
//        button.backgroundColor = .white
//        button.setTitleColor(.black, for: .normal)
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBlue
//        view.addSubview(button)
//        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        button.center = view.center
//    }
//    
//    @objc func didTapButton() {
//        let tabBarVC = UITabBarController()
//        
//        let vc1 = UINavigationController(rootViewController: FirstViewController())
//        let vc2 = UINavigationController(rootViewController: SecondViewController())
//        
//        vc1.title = "Home"
//        vc2.title = "History"
//        
//        tabBarVC.setViewControllers([vc1, vc2], animated: false)
//        
//        guard let items = tabBarVC.tabBar.items else  {
//            return
//        }
//             
//        let images = ["house", "bell"]
//        
//        for x in 0..<items.count {
//            items[x].badgeValue = "1"
//            items[x].image = UIImage(systemName: images[x])
//        }
//        
//        tabBarVC.modalPresentationStyle = .fullScreen
//        present(tabBarVC, animated: true)
//    }
//}
//
//class FirstViewController: UIViewController {
//    private var checkInButton: UIButton!
//    private var checkOutButton: UIButton!
//    private var checkInTime: Date?
//    private var checkOutTime: Date?
//    private var successLabel: UILabel!
//    private var shiftStartLabel: UILabel!
//    
//    // Core Data Managed Object Context
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        title = "Home"
//        
//        // Check-in Button
//        checkInButton = UIButton(type: .system)
//        configureButton(checkInButton, title: "Check In", yPosition: view.center.y - 70)
//        checkInButton.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
//        view.addSubview(checkInButton)
//        
//        // Check-out Button
//        checkOutButton = UIButton(type: .system)
//        configureButton(checkOutButton, title: "Check Out", yPosition: view.center.y + 20)
//        checkOutButton.addTarget(self, action: #selector(checkOut), for: .touchUpInside)
//        view.addSubview(checkOutButton)
//        
//        // Success Label
//        successLabel = UILabel(frame: CGRect(x: 20, y: view.frame.height - 150, width: view.frame.width - 40, height: 30))
//        successLabel.textAlignment = .center
//        successLabel.textColor = .green
//        view.addSubview(successLabel)
//        
//        // Shift Start Label
//        shiftStartLabel = UILabel(frame: CGRect(x: 20, y: view.frame.height - 200, width: view.frame.width - 40, height: 30))
//        shiftStartLabel.textAlignment = .center
//        shiftStartLabel.textColor = .green
//        view.addSubview(shiftStartLabel)
//        
//        // Load existing shift if any
//        loadExistingShift()
//    }
//    
//    private func configureButton(_ button: UIButton, title: String, yPosition: CGFloat) {
//        button.setTitle(title, for: .normal)
//        button.backgroundColor = .white
//        button.setTitleColor(.black, for: .normal)
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.cornerRadius = 10
//        button.frame = CGRect(x: view.center.x - 100, y: yPosition, width: 200, height: 50)
//    }
//    
//    // Check In Action
//    @objc func checkIn() {
//        checkInTime = Date()
//        saveCheckInTime(checkInTime!)
//        showAlert(message: "You have successfully checked in")
//    }
//    
//    // Check Out Action
//    @objc func checkOut() {
//        guard let checkInTime = checkInTime else {
//                    showAlert(message: "Please check in first.")
//                    return
//                }
//                checkOutTime = Date()
//                saveCheckOutTime(checkOutTime!)
//                showAlert(message: "You have successfully checked out")
//            }
//            
//            // Save Check In Time to Core Data
//            func saveCheckInTime(_ checkInTime: Date) {
//                let newShift = MyShift(context: context)
//                newShift.checkin = formatDate(date: checkInTime)
//                newShift.date = checkInTime
//                do {
//                    try context.save()
//                    print("Check-in saved to Core Data")
//                    loadExistingShift()
//                } catch {
//                    print("Error saving check-in: \(error.localizedDescription)")
//                }
//            }
//            
//            // Save Check Out Time to Core Data
//            func saveCheckOutTime(_ checkOutTime: Date) {
//                if let lastShift = getLastShift() {
//                    lastShift.checkout = formatDate(date: checkOutTime)
//                    do {
//                        try context.save()
//                        print("Check-out saved to Core Data")
//                        loadExistingShift()
//                    } catch {
//                        print("Error saving check-out: \(error.localizedDescription)")
//                    }
//                } else {
//                    print("No existing shift found to update check-out time")
//                }
//            }
//            
//            // Load Existing Shift
//            func loadExistingShift() {
//                if let lastShift = getLastShift() {
//                    if lastShift.checkout != nil {
//                        checkInTime = nil
//                        checkOutTime = nil
//                        successLabel.text = "Shift Ended"
//                    } else {
//                        checkInTime = lastShift.date
//                        checkOutTime = nil
//                        successLabel.text = "You have started the shift"
//                    }
//                    shiftStartLabel.text = "Shift started at \(lastShift.checkin ?? "")"
//                } else {
//                    successLabel.text = "No previous shift found"
//                    shiftStartLabel.text = ""
//                }
//            }
//            
//            // Get Last Shift
//            func getLastShift() -> MyShift? {
//                let fetchRequest: NSFetchRequest<MyShift> = MyShift.fetchRequest()
//                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//                fetchRequest.fetchLimit = 1
//                do {
//                    let shifts = try context.fetch(fetchRequest)
//                    return shifts.first
//                } catch {
//                    print("Error fetching shifts: \(error.localizedDescription)")
//                    return nil
//                }
//            }
//            
//            // Show Alert
//            func showAlert(message: String) {
//                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                present(alert, animated: true, completion: nil)
//            }
//            
//            // Format Date
//            func formatDate(date: Date) -> String {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                return dateFormatter.string(from: date)
//            }
//        }\
