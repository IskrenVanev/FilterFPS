#!/bin/bash


# Infinite loop for the main menu
while true; do
    # Display main menu options
    echo "1 - Display file properties and save to file"
    echo "2 - Search for a process ID by keyword and save to file"
    echo "3 - List processes"
    echo "4 - Exit"
    echo
    read -p "Enter your choice: " choice    # Prompt user for choice

    case $choice in     # Switch based on user's choice
              1)
            # Option to display file properties and save to file      
            read -p "Enter file name (with extension): " filename

            # Check if the file exists
            if [ -e "$filename" ]; then
                # Save file properties to file_properties.txt
                echo "File Properties:" > file_properties.txt
                stat "$filename" >> file_properties.txt
                echo "Output saved to file_properties.txt"
            else
                echo "Error: File '$filename' does not exist."
            fi
            ;;
# Option to search for a process ID by keyword and save to file
        2)
            read -p "Enter keyword: " keyword

            # Check if any processes match the provided keyword
            #-a: This option causes pgrep to display the entire command line of the matching processes.
            #-f: This option tells pgrep to interpret the pattern as a full command line, rather than just a process name.
            #"If there is a process running whose command line contains the specified 
            #keyword ($keyword), and that process is not the current script itself, then execute the code that follows."
            #grep: This command is used for searching text using patterns.
            #pgrep: This command searches for processes based on their names.
            #-v: Inverts the sense of matching, so it selects lines that do not match the specified pattern.
            #-w: Selects only those lines containing matches that form whole words.
            #-q: Quiet mode. Suppresses output; it's used to check the success or failure of the grep command without displaying the actual output.
            #$$: This is a special variable in shell scripts that represents the process ID (PID) of the script itself.
            #grep -v -wq $$ removes the line corresponding to the current script's process ID from
            # the list of processes matching the specified keyword.

            
            if pgrep -af "$keyword" | grep -v -wq $$; then
                pgrep -af "$keyword" | grep -v -w $$ > process_search.txt
                echo "Output saved to process_search.txt"
            else
                echo "No processes found matching the keyword '$keyword'."
            fi
            ;;
        3) 
        # Option to list processes by various criteria
            echo "List processes by:"
            echo "a - Process ID"
            echo "b - Process name"
            echo "c - Parent process name"
            echo "d - Execution time"
            read -p "Enter your choice: " processChoice
              # Switch based on user's sub-choice for listing processes
            case $processChoice in
                a)
                    echo "Listing processes by process ID:"
                    ps aux --sort=pid
                    ;;
                b)
                    echo "Listing processes by process name:"
                    ps aux --sort=comm
                    ;;
                c)
                    echo "Listing processes by parent process name:"
                    ps aux --sort=ppid
                    ;;
                d)
                    echo "Listing processes by execution time:"
                    ps aux --sort=start_time
                    ;;
                *)
                    echo "Invalid sub-choice for listing processes"
                    ;;
            esac
            ;;
        4)
        #exits the script
            exit
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
done