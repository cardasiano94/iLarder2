class log {
    
    var id: Int
    var date: String?
    var prod_id: Int
    var rate: Double
    var remaining: Int
    var new_remaining: Int
    
    init(id: Int, date: String?, prod_id: Int, rate: Double , remaining: Int, new_remaining: Int){
        self.id = id
        self.date = date
        self.prod_id = prod_id
        self.rate = rate
        self.remaining = remaining
        self.new_remaining = new_remaining
    }
}

