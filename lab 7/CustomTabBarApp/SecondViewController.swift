import UIKit
import CoreData

class SecondViewController: UIViewController {
    private let tableView = UITableView()
    private var shifts: [MyShift] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "History"
        
        setupTableView()
        fetchShifts()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func fetchShifts() {
        let fetchRequest: NSFetchRequest<MyShift> = MyShift.fetchRequest() as! NSFetchRequest<MyShift>
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            shifts = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching shifts: \(error.localizedDescription)")
        }
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let shift = shifts[indexPath.row]
        
        // Calculate duration of the shift
        let duration = calculateDuration(start: shift.date!, end: shift.checkout as? Date ?? Date())
        
        // Format the shift date, check-in and check-out times
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: shift.date!)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let checkInTime = dateFormatter.string(from: shift.date!)
        let checkOutTime = shift.checkout != nil ? dateFormatter.string(from: shift.checkout as? Date ?? Date()) : "Not checked out"
        
        cell.textLabel?.text = "Date: \(dateString), Clock In: \(checkInTime), Clock Out: \(checkOutTime), Duration: \(duration)"
        
        return cell
    }
    
    // Calculate duration between two dates
    private func calculateDuration(start: Date, end: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
        
        guard let hours = components.hour, let minutes = components.minute else {
            return "Unknown"
        }
        
        return "\(hours) hours \(minutes) minutes"
    }
}
