#!/bin/bash
echo "Welcome to the Number Guessing Game!"

# Replace with your actual credentials
DB_NAME="guessing_game"
DB_USER="your_username"
DB_PASSWORD="your_password"

# Generate a random number between 1 and 100
correct_answer=$(( RANDOM % 100 + 1 ))

# Function to save guess to the PostgreSQL database
save_guess() {
  PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -d $DB_NAME -c \
    "INSERT INTO guesses (username, guess, correct_answer) VALUES ('$1', $2, $correct_answer);"
}

# Game logic
while true; do
    read -p "Guess the number (1-100): " guess

    if ! [[ $guess =~ ^[0-9]+$ ]]; then
        echo "Please enter a valid number!"
        continue
    fi

    if (( guess == correct_answer )); then
        echo "Congratulations, $USER! You guessed the correct number!"
        save_guess $USER $guess
        break
    elif (( guess < correct_answer )); then
        echo "Higher..."
    else
        echo "Lower..."
    fi
done
