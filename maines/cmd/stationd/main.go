package main

import (
	"fmt"
	"log"
	"net"
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

	_, err = fmt.Fprintln(conn, "S01 48172 00691 33104")
	if err != nil {
		log.Println(err)
		return
	}
}
