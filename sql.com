-- Run this in your PostgreSQL shell (psql)
CREATE DATABASE guessing_game;

\c guessing_game

CREATE TABLE guesses(
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    guess INT,
    correct_answer INT,
    guess_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
