package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"
)

// Handling for Ctrl + C | Stale sockets

func main() {
	ctx, stop := signal.NotifyContext(
		context.Background(),
		os.Interrupt,
		syscall.SIGTERM,
	)
	defer stop()

	listener, err := net.Listen("unix", "./station.sock")
	if err != nil {
		log.Fatal(err)
	}

	defer fmt.Println("maines off air")
	defer listener.Close()

	go func() {
		<-ctx.Done()
		listener.Close()
	}()

	fmt.Println("maines online.")
	fmt.Println("waiting for listener...")

	conn, err := listener.Accept()
	if err != nil {
		if ctx.Err() == nil {
			log.Println("accept failed:", err)
		}
		return
	}
	defer conn.Close()

	go func() {
		<-ctx.Done()
		conn.Close()
	}()

	fmt.Println("listener connected")

	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()

	var sequence uint64

	for {
		select {
			case <-ctx.Done():
				return

			case now := <-ticker.C:
				sequence++

				_, err := fmt.Fprintf(
					conn,
					"%s M %07d 48172 00691 33104\n", // One-time Pad impl?
					now.UTC().Format("15:04:05"),
					sequence,
				)
				if err != nil {
					if ctx.Err() == nil {
						log.Println("transmission failed:", err)
					}
					return
				}
		}
	}
}
