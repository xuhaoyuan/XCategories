private let kMinute = 60
private let kDay = kMinute * 24
private let kWeek = kDay * 7
private let kMonth = kDay * 31
private let kYear = kDay * 365

extension Date {
    /// yyyy-MM-dd HH:mm
    var toString1: String {
        return DateFormatter.lineYMDHM.string(from: self)
    }
    /// yyyy.MM.dd
    var toString2: String {
        return DateFormatter.yearForPay.string(from: self)
    }
    /// "yyyy.MM.dd HH:mm"
    var toString3: String {
        return DateFormatter.yearForPay.string(from: self)
    }
}
extension DateFormatter {

    static public var yearForPay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }

    static public var dotYMDHM: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }
    
    static public var lineYMDHM: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }

    static public var dotMDHM: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd HH:mm"
        return formatter
    }

    static public var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter
    }

    static public var _year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    static public var full: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }

    static public var currentYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        return formatter
    }

    static public var simpleCurrentYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        return formatter
    }
    
    static public var hourMinute: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}

extension Calendar {

    func isDateInCurrentYear(_ date: Date) -> Bool {
        let currentYear = self.component(.year, from: Date())
        let dateYear = self.component(.year, from: date)
        return currentYear == dateYear
    }

    func isDateInPreviousYear(_ date: Date) -> Bool {
        let currentYear = self.component(.year, from: Date())
        let dateYear = self.component(.year, from: date)
        return currentYear == (dateYear + 1)
    }

    func isDateInPrevious(nDays: Int) -> (_ date: Date) -> Bool {
        return { date in
            return self.isDate(date, inSameDayAs: Date().addingTimeInterval(-TimeInterval(nDays * 60 * 60 * 24)))
        }
    }
}

extension Date {
    public var stringInIM: String {
        let calendar = Calendar.autoupdatingCurrent

        if calendar.isDateInToday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "%.2d:%.2d", hour, minute)
        } else {
            return DateFormatter.currentYear.string(from: self)
        }
    }

    public var stringInConversationList: String {
        let now = Date()
        let deltaSeconds = Int(now.timeIntervalSince(self))
        let calendar = Calendar.autoupdatingCurrent
        if deltaSeconds < 60 {
            return R.string.localizable.titleJust()
        } else if calendar.isDateInToday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "%.2d:%.2d", hour, minute)
        } else if calendar.isDateInYesterday(self) {
            return String(format: "昨天")
        } else {
            return DateFormatter.simpleCurrentYear.string(from: self)
        }
    }
}
/*
extension Date {

    public static func daysBetween(_ date1: Date, and date2: Date) -> Int {
        let calendar = Calendar.current

        let _date1 = calendar.startOfDay(for: date1)
        let _date2 = calendar.startOfDay(for: date2)

        let difference = calendar.dateComponents([.day], from: _date1, to: _date2)

        return abs(difference.day ?? 0)
    }

    public var circle_dateInDetail: String {
        let now = Date()
        let deltaSeconds = Int(now.timeIntervalSince(self))
        let deltaMinutes = deltaSeconds / 60
        let calendar = Calendar.autoupdatingCurrent
        if deltaSeconds < 60 {
            return R. LocalizedString.timeAgo(minutes: 1)
        } else if deltaMinutes < 60 {
            return LocalizedString.timeAgo(minutes: deltaMinutes)
        } else if calendar.isDateInToday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "%.2d:%.2d", hour, minute)
        } else if calendar.isDateInYesterday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "昨天 %.2d:%.2d", hour, minute)
        } else if calendar.isDateInPrevious(nDays: 2)(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "前天 %.2d:%.2d", hour, minute)
        } else if calendar.isDateInCurrentYear(self) {
//            let month = calendar.component(.month, from: self)
//            let day = calendar.component(.day, from: self)
//            let hour = calendar.component(.hour, from: self)
//            let minute = calendar.component(.minute, from: self)
//            return String(format: "%d月%d日 %.2d:%.2d", month, day, hour, minute)
            return DateFormatter.currentYear.string(from: self)
        } else {
            return DateFormatter.full.string(from: self)
        }
    }

    public var circle_dateOfConversation: String {
        let now = Date()
        let deltaSeconds = Int(now.timeIntervalSince(self))
        let deltaMinutes = deltaSeconds / 60
        let calendar = Calendar.autoupdatingCurrent
        if deltaSeconds < 5 {
            return LocalizedString.titleJustNow
        } else if deltaSeconds < 60 {
            return LocalizedString.timeAgo(minutes: 1)
        } else if deltaMinutes < 60 {
            return LocalizedString.timeAgo(minutes: deltaMinutes)
        } else if calendar.isDateInToday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "%.2d:%.2d", hour, minute)
        } else if calendar.isDateInYesterday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "昨天 %.2d:%.2d", hour, minute)
        } else if calendar.isDateInPrevious(nDays: 2)(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "前天 %.2d:%.2d", hour, minute)
        } else if calendar.isDateInCurrentYear(self) {
            let month = calendar.component(.month, from: self)
            let day = calendar.component(.day, from: self)
            return String(format: "%d月%d日", month, day)
        } else {
            return DateFormatter.full.string(from: self)
        }
    }

    public var circle_NewDateOfConversation: String {
        let calendar = Calendar.autoupdatingCurrent
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        let timeFormat = dateFormatter.string(from: self)
        if calendar.isDateInToday(self) {
            return timeFormat
        } else if calendar.isDateInYesterday(self) {
            return "昨天 \(timeFormat)"
        } else if calendar.isDateInPrevious(nDays: 2)(self) ||
            calendar.isDateInPrevious(nDays: 3)(self) ||
            calendar.isDateInPrevious(nDays: 4)(self) ||
            calendar.isDateInPrevious(nDays: 5)(self) ||
            calendar.isDateInPrevious(nDays: 6)(self) {
            dateFormatter.dateFormat = "EEEE"
            let weekFormat = dateFormatter.string(from: self)
            return weekFormat + " " + timeFormat
        } else {
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            return dateFormatter.string(from: self) + " " + timeFormat
        }
    }

    public var circle_dateOfConversationList: String {
        let calendar = Calendar.autoupdatingCurrent
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        let timeFormat = dateFormatter.string(from: self)

        if calendar.isDateInToday(self) {
            return timeFormat
        } else if calendar.isDateInYesterday(self) {
            return "昨天"
        } else if calendar.isDateInPrevious(nDays: 2)(self) ||
            calendar.isDateInPrevious(nDays: 3)(self) ||
            calendar.isDateInPrevious(nDays: 4)(self) ||
            calendar.isDateInPrevious(nDays: 5)(self) ||
            calendar.isDateInPrevious(nDays: 6)(self) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd"
            return formatter.string(from: self)
        }
    }

    public var circle_dateInList: String {
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60
        let calendar = Calendar.autoupdatingCurrent

        if deltaSeconds < 60 {
            return LocalizedString.timeAgo(minutes: 1)
        } else if deltaMinutes < 60 {
            return LocalizedString.timeAgo(minutes: deltaMinutes)
        } else if deltaMinutes < 120 {
            return LocalizedString.titleTimeAgoOneHour
        } else if deltaMinutes < kDay {
            let value = Int(floor(Float(deltaMinutes / kMinute)))
            let timeValue: Int = value
            return LocalizedString.timeAgo(hours: timeValue)
        } else if calendar.isDateInYesterday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "昨天 %.2d:%.2d", hour, minute)
        } else if calendar.isDateInCurrentYear(self) {
            let month = calendar.component(.month, from: self)
            let day = calendar.component(.day, from: self)
            return "\(month)月\(day)日"
        } else {
            return DateFormatter.year.string(from: self)
        }
    }

    public var circle_dateFullFormat: String {
        return DateFormatter.full.string(from: self)
    }

    public var circle_dateInHomePage: String {
        return DateFormatter._year.string(from: self)
    }

    public var circle_dateForPay: String {
        return DateFormatter.yearForPay.string(from: self)
    }

    public var circle_date_day: String {
        let calendar = Calendar.autoupdatingCurrent
        if calendar.isDateInToday(self) {
            return "今天"
        } else if calendar.isDateInYesterday(self) {
            return "昨天"
        } else if calendar.isDateInCurrentYear(self) {
            let month = calendar.component(.month, from: self)
            let day = calendar.component(.day, from: self)
            return "\(month)月\(day)日"
        } else {
            return DateFormatter.year.string(from: self)
        }
    }

    public var circle_dateInMessage: String {
        let calendar = Calendar.autoupdatingCurrent
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let string = String(format: "%.2d:%.2d", hour, minute)
        return string
    }
    
    public var live_card_date: String {
         let calendar = Calendar.autoupdatingCurrent
         if calendar.isDateInToday(self) {
            return "今天 \(DateFormatter.hourMinute.string(from: self))"
         } else if calendar.isDateInTomorrow(self) {
             return "明天 \(DateFormatter.hourMinute.string(from: self))"
         } else if calendar.isDateInCurrentYear(self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "M月d日 HH:mm"
             return formatter.string(from: self)
         } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月d日 HH:mm"
             return DateFormatter.year.string(from: self)
         }
     }
}
*/
