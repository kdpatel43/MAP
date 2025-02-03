import Foundation

// This represents a student who is trying to enroll in a course
class Student {
    var name: String
    var age: Int
    var studentID: String

    init(name: String, age: Int, studentID: String) {
        self.name = name
        self.age = age
        self.studentID = studentID
    }
}

// This is a custom error type that will help us manage enrollment issues
enum EnrollmentError: Error, LocalizedError {
    case ageRestriction(minAge: Int)
    case prerequisiteNotMet(prerequisite: String)
    case paymentFailed(reason: String)

    // Human-readable error messages for each case
    var errorDescription: String? {
        switch self {
        case .ageRestriction(let minAge):
            return "Student must be at least \(minAge) years old to enroll."
        case .prerequisiteNotMet(let prerequisite):
            return "Student has not met the prerequisite: \(prerequisite)."
        case .paymentFailed(let reason):
            return "Payment failed due to: \(reason)."
        }
    }
}

// This class represents a course that students can enroll in
class Course {
    var title: String
    var availableSlots: Int
    var prerequisites: [String] = []
    var schedule: [String] = [] // Available time slots
    private var enrolledStudents: [Student] = []
    private var waitlist: [Student] = []

    init(title: String, availableSlots: Int) {
        self.title = title
        self.availableSlots = availableSlots
    }

    // Method to enroll a student into the course
    func enrollStudent(student: Student, minAge: Int, prerequisite: String?) -> Result<String, EnrollmentError> {
        // Check if the student meets the minimum age requirement
        if student.age < minAge {
            return .failure(.ageRestriction(minAge: minAge))
        }
        
        // Check if the student meets the prerequisites (if any)
        if let prerequisite = prerequisite, !student.studentID.hasPrefix(prerequisite) {
            return .failure(.prerequisiteNotMet(prerequisite: prerequisite))
        }
        
        // Check if there's room for more students
        if enrolledStudents.count < availableSlots {
            enrolledStudents.append(student)
            return .success("\(student.name) enrolled successfully!")
        } else {
            waitlist.append(student)
            return .success("\(student.name) added to the waitlist.")
        }
    }

    // Method to handle payment verification
    func verifyPayment(for student: Student) -> Result<String, EnrollmentError> {
        // Simulate a payment check
        let paymentSuccess = Bool.random()
        
        if paymentSuccess {
            return .success("Payment successful for \(student.name).")
        } else {
            return .failure(.paymentFailed(reason: "Payment gateway error"))
        }
    }

    // Method to display the enrollment status for students
    func displayEnrollmentStatus() {
        print("=== Enrollment Status for \(title) ===")
        for student in enrolledStudents {
            print("\(student.name) is successfully enrolled.")
        }
        for student in waitlist {
            print("\(student.name) is on the waitlist.")
        }
    }

    // Method to show available slots for enrollment
    func availableSeats() -> Int {
        return availableSlots - enrolledStudents.count
    }

    // Method to schedule the course
    func scheduleCourse(timeSlots: [String]) {
        self.schedule = timeSlots
    }

    // Method to handle potential schedule conflicts
    func checkScheduleConflict(for student: Student, selectedSlot: String) -> Bool {
        return schedule.contains(selectedSlot)
    }
}

// This part deals with managing the course enrollment process for multiple students
class EnrollmentSystem {
    var courses: [Course] = []
    var students: [Student] = []

    // Add a course to the system
    func addCourse(course: Course) {
        courses.append(course)
    }

    // Add a student to the system
    func addStudent(student: Student) {
        students.append(student)
    }

    // Enroll a student in a course after validating age, prerequisites, and payment
    func enrollStudentInCourse(student: Student, course: Course, minAge: Int, prerequisite: String?) {
        let enrollmentResult = course.enrollStudent(student: student, minAge: minAge, prerequisite: prerequisite)
        switch enrollmentResult {
        case .success(let message):
            print(message)
            let paymentResult = course.verifyPayment(for: student)
            switch paymentResult {
            case .success(let paymentMessage):
                print(paymentMessage)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }

    // Display enrollment status for each course
    func displayAllEnrollmentStatuses() {
        for course in courses {
            course.displayEnrollmentStatus()
        }
    }
}

// Example usage
let student1 = Student(name: "John Doe", age: 18, studentID: "S001")
let student2 = Student(name: "Jane Smith", age: 20, studentID: "S002")
let student3 = Student(name: "Alice Johnson", age: 22, studentID: "S003")

let course1 = Course(title: "Swift Programming", availableSlots: 2)
let course2 = Course(title: "Java Programming", availableSlots: 1)

let enrollmentSystem = EnrollmentSystem()

// Add courses to the system
enrollmentSystem.addCourse(course: course1)
enrollmentSystem.addCourse(course: course2)

// Add students to the system
enrollmentSystem.addStudent(student: student1)
enrollmentSystem.addStudent(student: student2)
enrollmentSystem.addStudent(student: student3)

// Enroll students in courses
enrollmentSystem.enrollStudentInCourse(student: student1, course: course1, minAge: 21, prerequisite: "CS101")
enrollmentSystem.enrollStudentInCourse(student: student2, course: course1, minAge: 21, prerequisite: "CS101")
enrollmentSystem.enrollStudentInCourse(student: student3, course: course1, minAge: 21, prerequisite: "CS101")

// Display enrollment statuses
enrollmentSystem.displayAllEnrollmentStatuses()

