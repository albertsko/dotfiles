package main

import "github.com/albertsko/dotfiles/apps/gdrive/rclonebisync"

func main() {
	_, err := rclonebisync.New("gdrive", 300)
	if err != nil {
		panic(err)
	}
}
