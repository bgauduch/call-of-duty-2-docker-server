package main

/**
 * A command like cat(1)
 *
 *    $ cat foo.txt
 *    $ cat foo.txt bar.txt
 *    $ cat < foo.txt
 */

import (
	"io"
	"log"
	"os"
)

func readWrite(src io.Reader, dst io.Writer) {
}

func main() {
	if len(os.Args) == 1 {
		_, err := io.Copy(os.Stdout, os.Stdin)
		if err != nil {
			log.Fatal(err)
		}
	} else {
		for _, fname := range os.Args[1:] {
			fh, err := os.Open(fname)
			if err != nil {
				log.Fatal(err)
			}

			_, err = io.Copy(os.Stdout, fh)
			if err != nil {
				log.Fatal(err)
			}
		}
	}
}
