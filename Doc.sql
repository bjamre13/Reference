
// database creation

CREATE DATABASE customer_support_ticket_system;
USE customer_support_ticket_system;


// tables

-- USER TABLE
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ROLE TABLE
CREATE TABLE roles (
    role_id BIGINT PRIMARY KEY,
    name VARCHAR(50) NOT NULL CHECK (name IN ('CUSTOMER', 'AGENT', 'ADMIN'))
);

-- USER_ROLE JOIN TABLE
CREATE TABLE user_role (
    user_id BIGINT REFERENCES users(user_id) ON DELETE CASCADE,
    role_id BIGINT REFERENCES roles(role_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- TICKET TABLE
CREATE TABLE tickets (
    ticket_id BIGINT PRIMARY KEY,
    customer_id BIGINT REFERENCES users(user_id) ON DELETE SET NULL,
    agent_id BIGINT REFERENCES users(user_id) ON DELETE SET NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    priority VARCHAR(50) NOT NULL CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- COMMENT TABLE
CREATE TABLE comments (
    comment_id BIGINT PRIMARY KEY,
    ticket_id BIGINT REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(user_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ATTACHMENT TABLE
CREATE TABLE attachments (
    attachment_id BIGINT PRIMARY KEY,
    ticket_id BIGINT REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    file_path TEXT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- NOTIFICATION TABLE
CREATE TABLE notifications (
    notification_id BIGINT PRIMARY KEY,
    user_id BIGINT REFERENCES users(user_id) ON DELETE CASCADE,
    ticket_id BIGINT REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TICKET REMINDER TABLE
CREATE TABLE ticket_reminders (
    reminder_id BIGINT PRIMARY KEY,
    ticket_id BIGINT REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    reminder_time TIMESTAMP NOT NULL,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FEEDBACK TABLE
CREATE TABLE feedback (
    feedback_id BIGINT PRIMARY KEY,
    ticket_id BIGINT UNIQUE REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
