package main

import (
	"bufio"
	"fmt"
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

	message, err := reader.ReadString('\n')
	if err != nil {
		log.Println(err)
		return
	}

	fmt.Print(message)
}
