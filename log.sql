/* Available data of the crime:
Date: July 28, 2021
Place: Humphrey Street, Fiftyville
*/

-- Query crime_scene_reports looking for a description.
SELECT description
FROM crime_scene_reports
WHERE street = "Humphrey Street"
AND year = 2021
AND month = 7
AND day = 28
AND description LIKE "%CS50%";
-- Obtained description mentioned the exact time and place of the theft (Humphrey Street bakery, 10:15 am) and, also, interviews that were conducted, at that day, with three witnesses.

-- Query to get the transcript of the interviews that held place referring the theft of the CS50 duck and mention a bakery.
SELECT transcript
FROM interviews
WHERE year = 2021
AND month = 7
AND day = 28
AND transcript LIKE "%bakery%";
-- First interview mentioned the bakery parking lot ten minuted after the theft(10:15 to 10:25)
-- Second interview mentioned the thief withdrawed money in the ATM on Leggett Street
-- Third interview mentioned thief has an accomplice and, also, this accomplice would purchase the earliest flight ticket on the next day

-- Query to get the mentioned bakery security footage
SELECT activity AS act, license_plate AS lic
FROM bakery_security_logs
WHERE year = 2021
AND month = 7
AND day = 28
AND hour = 10
AND minute BETWEEN 15 AND 25;
-- Query brings back 8 possible car plates to take any clue

-- Query to get the ATM transactions in the mentioned street
SELECT account_number
FROM atm_transactions
WHERE atm_location = "Leggett Street"
AND year = 2021
AND month = 7
AND day = 28
AND transaction_type = "withdraw";
-- Query brings back 7 possible account numbers the thief could belong to

-- Query to retrieve phone calls that were made that day, with a duration less than a minute, as the witness said
SELECT caller
FROM phone_calls
WHERE year = 2021
AND month = 7
AND day = 28
AND duration < 60;
-- Query retrieves 9 possible phone that could correspond to the thief

-- Query to get the earliest flight destionation that correspond to July 29, 2021 from Fiftyville
SELECT city
FROM airports
WHERE id =
(
    SELECT destination_airport_id
    FROM flights
    INNER JOIN airports
    ON flights.origin_airport_id = airports.id
    WHERE airports.city = "Fiftyville"
    AND year = 2021
    AND month = 7
    AND day = 28 + (1)
    ORDER BY hour
    LIMIT 1
);
-- Destination results in New York City (the city the thief escaped to)

-- Query to get the passport numbers of passengers
SELECT passport_number
FROM passengers
WHERE flight_id =
(
    SELECT flights.id
    FROM flights
    INNER JOIN airports
    ON flights.origin_airport_id = airports.id
    WHERE airports.city = "Fiftyville"
    AND year = 2021
    AND month = 7
    AND day = 28 + (1)
    ORDER BY hour
    LIMIT 1
);
-- Query retrieves 8 possible results that could match the thief

-- Chained query to retrieve the thief with collected data
SELECT name
FROM people
WHERE id IN (
    SELECT person_id
    FROM bank_accounts
    WHERE account_number IN (
        SELECT account_number
        FROM atm_transactions
        WHERE atm_location = "Leggett Street"
        AND year = 2021
        AND month = 7
        AND day = 28
        AND transaction_type = "withdraw"
    )
) AND license_plate IN (
    SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2021
    AND month = 7
    AND day = 28
    AND hour = 10
    AND minute BETWEEN 15 AND 25
) AND phone_number IN (
    SELECT caller
    FROM phone_calls
    WHERE year = 2021
    AND month = 7
    AND day = 28
    AND duration < 60
) AND passport_number IN (
    SELECT passport_number
    FROM passengers
    WHERE flight_id =
    (
        SELECT flights.id
        FROM flights
        INNER JOIN airports
        ON flights.origin_airport_id = airports.id
        WHERE airports.city = "Fiftyville"
        AND year = 2021
        AND month = 7
        AND day = 28 + (1)
        ORDER BY hour
        LIMIT 1
    )
);
-- Query retrieves the name of the possible thief (Bruce)

-- Final query to determine the accomplice
SELECT name
FROM people
WHERE phone_number = (
    SELECT receiver
    FROM phone_calls
    WHERE year = 2021
    AND month = 7
    AND day = 28
    AND duration < 60
    AND caller = (
        SELECT phone_number
        FROM people
        WHERE name = (
            SELECT name
            FROM people
            WHERE id IN (
                SELECT person_id
                FROM bank_accounts
                WHERE account_number IN (
                    SELECT account_number
                    FROM atm_transactions
                    WHERE atm_location = "Leggett Street"
                    AND year = 2021
                    AND month = 7
                    AND day = 28
                    AND transaction_type = "withdraw"
                )
            ) AND license_plate IN (
                SELECT license_plate
                FROM bakery_security_logs
                WHERE year = 2021
                AND month = 7
                AND day = 28
                AND hour = 10
                AND minute BETWEEN 15 AND 25
            ) AND phone_number IN (
                SELECT caller
                FROM phone_calls
                WHERE year = 2021
                AND month = 7
                AND day = 28
                AND duration < 60
            ) AND passport_number IN (
                SELECT passport_number
                FROM passengers
                WHERE flight_id =
                (
                    SELECT flights.id
                    FROM flights
                    INNER JOIN airports
                    ON flights.origin_airport_id = airports.id
                    WHERE airports.city = "Fiftyville"
                    AND year = 2021
                    AND month = 7
                    AND day = 28 + (1)
                    ORDER BY hour
                    LIMIT 1
                )
            )
        )
    )
);
-- Query retrieves the possible name of the accomplice (Robin)