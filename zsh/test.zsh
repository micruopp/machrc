# test file


__print_color() {
    local colorcode=$1
    printf "\e[48;5;%sm%4d\e[0m" "$colorcode" "$colorcode"
}

__test_256_color() {
  echo -n "\n\t"
  
  echo "$(tput bold)ANSI (standard)$(tput sgr0)"
  echo -n "\t"
  for i in {0..15}; do
      __print_color "$i"
      if (( (i + 1) % 8 == 0 )); then
          echo
          echo -n "\t"
      fi
  done

  echo -n "\n\t"

  echo "$(tput bold)256 (8-bit)$(tput sgr0)"
  echo -n "\t"
  for i in {16..231}; do
      __print_color "$i"
      if (( (i - 16 + 1) % 36 == 0 )); then
          echo
      fi
      if (( (i - 16 + 1) % 6 == 0 )); then
          echo
          echo -n "\t"
      fi
  done

  # Grayscale
  echo "$(tput bold)ANSI (grayscale)$(tput sgr0)"
  echo -n "\t"
  for i in {232..255}; do
      __print_color "$i"
      if (( (i - 232 + 1) % 12 == 0 )); then
          echo
          echo -n "\t"
      fi
  done

  echo -n "\n"
}
alias 256="__test_256_color"

# just kind of a test script
# you know, to see how things are working
wow() {
  # FIXME: escape any input so it only prints it raw
  #   - `wow "$(echo `echo 'something devious'`)"`
  #     > something devious
  #     or
  #     `wow "$(echo `echo $(( 8 + 8 )) >> mal.txt`)" `
  #     > L I K E   R I G H T   N O W 
  #     and a new file named `mal.txt` with the contents of "16"
  #     I would like this to simply output
  #     > $(echo `echo $(( 8 + 8 )) >> mal.txt`)
  #     in yellow italics, blinking

  message="$*"
  if [ -z "$message" ] ; then
    message="L I K E   R I G H T   N O W"
  fi

  styled_message="$blinkon$boldon$italon$fgyellow$message$resetall"

  local message_length=${#message}
  # assuming a message of one line for now
  #local numlines=$(echo "$message" | grep -c '^')

  local rows=$(tput lines)
  local cols=$(tput cols)

  local padding_x=$(( (cols - message_length) / 2 ))
  local padding_y=$(( (rows - 1 - 3) / 2 )) # minus 3 for the prompt height

  # clear the screen first
  clear

  # print top padding
  for ((i = 0; i < padding_y; i++)); do
    echo ""
  done

  # print an additional line of top padding if the overall height is even
  if (( rows % 2 == 0 )); then
    echo ""
  fi

  # print the message
  padded_message=$(printf "%${padding_x}s%s" "" "$styled_message")
  echo "$padded_message"

  # print bottom padding
  for ((i = 0; i < padding_y; i++)); do
    echo ""
  done
}

test-cal() {
  cal -3 |
  while IFS="\n" read -r line
  do
    #echo "$line"
    printf "%s", $line
  done
}

# you can do this! 
utils.sayhi() {
  print "%s" "hello, there!"
}


test_print_colors_with_tput() {
  # Set bright colors using tput
  for color in 9 10 11 12 13 14 15; do
      tput setaf $color
      echo "This is bright color $color"
  done

  # Reset to default color
  tput sgr0
}

# Define color codes
colors=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)

# Define text attributes
attributes=(bold underline blink reverse reset)

# Define background colors
bg_colors=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)

# Function to test colors
test_colors() {
    echo "Testing foreground colors:"
    for color in "${colors[@]}"; do
        tput setaf $color
        echo -n "Color $color  "
    done
    tput sgr0
    echo
}

# Function to test background colors
test_bg_colors() {
    echo "Testing background colors:"
    for color in "${bg_colors[@]}"; do
        tput setab $color
        echo -n "BG Color $color  "
    done
    tput sgr0
    echo
}

# Function to test text attributes
test_attributes() {
    echo "Testing text attributes:"
    for attr in "${attributes[@]}"; do
        case $attr in
            bold)    attr_code=$(tput bold) ;;
            underline) attr_code=$(tput smul) ;;
            blink)   attr_code=$(tput blink) ;;
            reverse) attr_code=$(tput rev) ;;
            reset)   attr_code=$(tput sgr0) ;;
        esac
        echo -n "${attr_code}This is $attr text${reset_code}  "
    done
    tput sgr0
    echo
}

test__run_tests() {
  test_colors
  test_bg_colors
  test_attributes
}

test.rendering() {
  test__run_tests
}
