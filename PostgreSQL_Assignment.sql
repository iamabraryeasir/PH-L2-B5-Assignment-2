-- creating new db for assignment
CREATE DATABASE conservation_db;

-- creating tables
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(30) NOT NULL
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL,
    species_id INT NOT NULL,
    sighting_time TIMESTAMP NOT NULL DEFAULT NOW(),
    location VARCHAR(50) NOT NULL,
    notes VARCHAR(200),
    FOREIGN KEY (ranger_id) REFERENCES rangers (ranger_id),
    FOREIGN KEY (species_id) REFERENCES species (species_id)
);

-- viewing the tables
SELECT * FROM rangers;

SELECT * FROM species;

SELECT * FROM sightings;

-- deleting table
DROP TABLE rangers;

DROP TABLE species;

DROP TABLE sightings;

-- inserting data into the tables
INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- Problem 1
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2
SELECT count(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3
SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- Problem 4
SELECT r.name AS name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
    JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY
    r.ranger_id,
    r.name
ORDER BY r.name;

-- Problem 5
SELECT sp.common_name
FROM species sp
    LEFT JOIN sightings s ON sp.species_id = s.species_id
WHERE
    s.sighting_id IS NULL;

-- Problem 6
SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings s
    JOIN species sp ON s.species_id = sp.species_id
    JOIN rangers r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problem 7
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01';

-- Problem 8
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 16  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings
ORDER BY sighting_id;

-- Problem 9
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );