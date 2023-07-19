#!/usr/bin/expect -f

# Set the timeout to 1800 seconds (30 minutes)
set timeout 1800

# Get the command and licenses from command-line arguments
set cmd [lindex $argv 0]
set licenses [lindex $argv 1]

# Start a new process with the provided command
spawn {*}$cmd

# Expect the pattern "(y/N)" in the process output
expect {
    # If the pattern is found, automatically send "y" followed by a carriage return (\r)
    "(y/N)" {
        exp_send "y\r"
        # Continue to wait for the pattern in case it appears again
        exp_continue
    }
    # If the process has finished, stop waiting and continue with the script
    eof
}
