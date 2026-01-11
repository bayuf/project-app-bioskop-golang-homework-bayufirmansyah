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

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- Studios
CREATE TABLE studios (
    id SERIAL PRIMARY KEY,
    cinema_id INT NOT NULL REFERENCES cinemas(id),
    name VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_studio_name UNIQUE (cinema_id, name)
);

-- total seats
CREATE TABLE seats (
    id SERIAL PRIMARY KEY,
    studio_id INT NOT NULL REFERENCES studios(id),
    seat_code VARCHAR(5) NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_seat UNIQUE (studio_id, seat_code)
);

-- movie schedules
CREATE TABLE movie_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    studio_id INT NOT NULL REFERENCES studios(id),
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    price NUMERIC(10,2) NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_schedule UNIQUE (studio_id, show_date, show_time)
);

-- bookings
CREATE TABLE bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    schedule_id UUID NOT NULL REFERENCES movie_schedules(id),

    status VARCHAR(20) NOT NULL
        CHECK (status IN ('PENDING', 'PAID', 'CANCELLED')),

    total_price NUMERIC(10,2) NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- booking seats
CREATE TABLE booking_seats (
    booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    seat_id INT NOT NULL REFERENCES seats(id),

    PRIMARY KEY (booking_id, seat_id)
);

CREATE UNIQUE INDEX uq_seat_schedule_booking
ON booking_seats (seat_id)
WHERE booking_id IN (
    SELECT id FROM bookings
    WHERE status IN ('PENDING', 'PAID')
);

-- payment method
CREATE TABLE payment_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_payment_method UNIQUE (name)
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

    created_at TIMESTAMPTZ DEFAULT NOW()
);
