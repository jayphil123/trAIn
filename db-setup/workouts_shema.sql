CREATE TABLE workouts (
    id SERIAL PRIMARY KEY,                                                        -- Auto-incrementing primary key
    name VARCHAR(255) NOT NULL,                                                   -- Exercise name
    force VARCHAR(50),                                                            -- Type of force (push/pull)
    level VARCHAR(50),                                                            -- Difficulty level
    mechanic VARCHAR(50),                                                         -- Exercise mechanic type
    equipment VARCHAR(255),                                                       -- Equipment required
    primary_muscles VARCHAR(255),                                                 -- Primary muscles targeted (array of strings)
    secondary_muscles VARCHAR(255),                                               -- Secondary muscles targeted (array of strings)
    instructions VARCHAR(5000),                                                   -- Array of instructions for the workout
    category VARCHAR(100),                                                        -- Category of the exercise (e.g., strength, cardio)
    images VARCHAR(255),                                                          -- Array of image paths
    id_str VARCHAR(100)                                                           -- Unique identifier for the exercise
);
