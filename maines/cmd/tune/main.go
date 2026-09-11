package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
)

func main() {
	conn, err := net.Dial("unix", "./station.sock")
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	fmt.Println("connected to maines")
	reader := bufio.NewReader(conn)

	for {
		message, err := reader.ReadString('\n')
		if err != nil {
			if err == io.EOF {
				fmt.Println("station is off air.")
			} else {
				log.Println("receive failed:", err)
			}
			return
		}

		fmt.Print(message)
	}
}
