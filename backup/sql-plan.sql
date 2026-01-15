-- User Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    email VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    password_hash TEXT NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_users_email UNIQUE (email)
);

-- OTP
CREATE TABLE verification_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    code_hash TEXT NOT NULL,              -- hash dari angka acak
    purpose VARCHAR(30) NOT NULL,         -- login, verify_email, reset_password

    expired_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- Session
CREATE TABLE sessions (
    token UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    expired_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Cinemas
CREATE TABLE cinemas (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_cinemas_name_location UNIQUE (name, location)
);


-- Studios
CREATE TABLE studios (
    id SERIAL PRIMARY KEY,
    cinema_id INT NOT NULL REFERENCES cinemas(id),
    name VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL CHECK (total_seats > 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_studio_name UNIQUE (cinema_id, name)
);


-- total seats
CREATE TABLE seats (
    id SERIAL PRIMARY KEY,
    studio_id INT NOT NULL REFERENCES studios(id),
    seat_code VARCHAR(5) NOT NULL
        CHECK (seat_code ~ '^[A-Z][0-9]{1,2}$'),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_seat UNIQUE (studio_id, seat_code)
);

-- movies
CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),

    synopsis TEXT,
    language VARCHAR(30),
    age_rating VARCHAR(10), -- SU, 13+, 17+

    poster_url TEXT,
    trailer_url TEXT,
    release_date DATE NOT NULL,
    end_date DATE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE movie_genres (
    movie_id INT NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
    genre_id INT NOT NULL REFERENCES genres(id) ON DELETE CASCADE,

    PRIMARY KEY (movie_id, genre_id)
);

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    avatar_url TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE movie_people (
    movie_id INT NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
    person_id INT NOT NULL REFERENCES people(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('director', 'actor')),

    PRIMARY KEY (movie_id, person_id, role)
);

-- movie schedules
CREATE TABLE movie_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    studio_id INT NOT NULL REFERENCES studios(id),
    movie_id INT NOT NULL REFERENCES movies(id),
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_schedule UNIQUE (studio_id, show_date, show_time)
);

CREATE TABLE movie_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    movie_id INT NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_movie_user_rating UNIQUE (movie_id, user_id)
);


-- bookings
CREATE TABLE bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    schedule_id UUID NOT NULL REFERENCES movie_schedules(id),

    status VARCHAR(20) NOT NULL
        CHECK (status IN ('RESERVED', 'PAID', 'CANCELLED')),

    total_price NUMERIC(10,2) NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
    expired_at TIMESTAMP NOT NULL
);

-- booking seats
CREATE TABLE booking_seats (
    booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    schedule_id UUID NOT NULL REFERENCES movie_schedules(id),
    seat_id INT NOT NULL REFERENCES seats(id),

    PRIMARY KEY (booking_id, seat_id)
);


CREATE UNIQUE INDEX uq_seat_schedule_active
ON booking_seats (schedule_id, seat_id)
WHERE booking_status IN ('RESERVED', 'PAID');


-- payment method
CREATE TABLE payment_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);


-- payment
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES bookings(id),
    payment_method_id INT NOT NULL REFERENCES payment_methods(id),

    amount NUMERIC(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('SUCCESS', 'FAILED')),

    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT uq_payment_booking UNIQUE (booking_id)
);
