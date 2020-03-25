match($0, /OTP-(([0-9]+)(.[0-9]+)*(-[0-9a-zA-Z]*){0,1})$/, ary) {
		rev = $1
    ver = ary[1]

		cmd = "./get-version-details " ver " " rev

		while ( ( cmd | getline sha256 ) > 0 ) {
			print ver " " rev " " sha256
		}

		close(cmd);
}
