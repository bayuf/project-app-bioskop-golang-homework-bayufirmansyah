package dto

type Email struct {
	To      string `json:"to"`
	Name    string `json:"name"`
	Subject string `json:"subject"`
	Message string `json:"text"`
}
