package main

import (
	"fmt"
	"log"
	"net"
	"time"
)

func main() {
	listener, err := net.Listen("unix", "./station.sock")
	if err != nil {
		log.Fatal(err)
	}
	defer listener.Close()

	fmt.Println("maines - online")
	fmt.Println("waiting for listener...")

	conn, err := listener.Accept()
	if err != nil {
		log.Println(err)
		return
	}
	defer conn.Close()

	fmt.Println("listener connected")

	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()
	
	var sequence uint64

	for now := range ticker.C {
		sequence ++

		_, err := fmt.Fprintf(
			conn,
			"%s S01 #%06d 48172 00691 33104\n",
			now.UTC().Format("15:04:05"),
			sequence,
		)
		if err != nil {
			log.Println("transmission failed:", err)
			return
		}
	}
}
