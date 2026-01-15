package dto

type TicketRes struct {
	BookingID  string `json:"booking_id"`
	MovieTitle string `json:"title"`
	BannerURL  string `json:"banner_url"`
	Duration   string `json:"duration"`
	Studio     string `json:"studio"`
	Seat       string `json:"seat"`
	Price      int    `json:"price"`
}
