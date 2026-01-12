package utils

import (
	"fmt"
	"sync"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
)

type EmailJob struct {
	Payload *dto.Email
}

type EmailSender interface {
	SendEmail(email *dto.Email) error
}

// Worker pool
func StartEmailWorkers(workerCount int, jobs <-chan EmailJob, stop <-chan struct{}, metrics *Metrics, wg *sync.WaitGroup, emailUc EmailSender) {
	wg.Add(workerCount)

	for i := 1; i <= workerCount; i++ {
		go func(id int) {
			defer wg.Done()

			for {
				select {
				case job, ok := <-jobs:
					if !ok {
						fmt.Println("worker", id, "jobs channel closed")
						return
					}

					// send email
					if err := emailUc.SendEmail(job.Payload); err != nil {
						fmt.Println("email failed:", err)
						metrics.Failed()
						continue
					}

					metrics.Sent()

				case <-stop:
					fmt.Println("worker", id, "received stop signal")
					return
				}
			}
		}(i)
	}
}
