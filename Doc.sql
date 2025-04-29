
// database creation

CREATE DATABASE customer_support_ticket_system;
USE customer_support_ticket_system;


// tables

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(20) CHECK (name IN ('CUSTOMER', 'AGENT', 'ADMIN')) 
    -- NOT NULL
);

CREATE TABLE user_role (
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    role_id INTEGER REFERENCES roles(role_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    agent_id INTEGER REFERENCES users(user_id),
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')) DEFAULT 'OPEN',
    priority VARCHAR(20) CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')) DEFAULT 'MEDIUM',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE attachments (
    attachment_id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    file_path TEXT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    ticket_id INTEGER REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ticket_reminders (
    reminder_id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    reminder_time TIMESTAMP NOT NULL,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

//values


-- Insert roles
INSERT INTO roles (name) VALUES 
('ADMIN'),
('AGENT'),
('CUSTOMER');

-- Insert users
INSERT INTO users (name, email, password_hash) VALUES
('Alice Johnson', 'alice@example.com', 'hashed_password_1'),
('Bob Smith', 'bob@example.com', 'hashed_password_2'),
('Clara Davis', 'clara@example.com', 'hashed_password_3');

-- Assign roles to users
INSERT INTO user_role (user_id, role_id) VALUES
(1, 1),  -- Alice is a CUSTOMER
(2, 2),  -- Bob is an AGENT
(3, 3),  -- Clara is an ADMIN
(3, 2);  -- Clara is also an AGENT

-- Insert tickets
INSERT INTO tickets (customer_id, agent_id, subject, description, status, priority) VALUES
(1, 2, 'Login Issue', 'Unable to log into the account.', 'OPEN', 'HIGH'),
(1, NULL, 'Payment Failure', 'Payment was declined without reason.', 'OPEN', 'MEDIUM');

-- Insert ticket comments
INSERT INTO comments (ticket_id, user_id, content, is_internal) VALUES
(1, 2, 'Investigating the login issue.', TRUE),
(1, 2, 'We are looking into your issue.', FALSE);

INSERT INTO attachments (ticket_id, file_path) VALUES
(1, '/uploads/login_error.png'),
(2, '/uploads/payment_receipt.jpg');

INSERT INTO notifications (user_id, ticket_id, message) VALUES
(1, 1, 'Your ticket has been assigned to an agent.'),
(1, 2, 'Your ticket is under review.');

INSERT INTO ticket_reminders (ticket_id, reminder_time, message) VALUES
(1, NOW() + INTERVAL '1 day', 'Follow up with customer on login issue.');

INSERT INTO feedback (ticket_id, rating, comment) VALUES
(1, 4, 'Good support, issue resolved quickly.');
