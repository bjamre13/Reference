
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


// Values

INSERT INTO roles (role_id, name) VALUES 
(1, 'CUSTOMER'),
(2, 'AGENT'),
(3, 'ADMIN');

INSERT INTO users (user_id, name, email, password_hash) VALUES
(1001, 'Alice Johnson', 'alice@example.com', 'hashed_password_1'),
(1002, 'Bob Smith', 'bob@example.com', 'hashed_password_2'),
(1003, 'Charlie Admin', 'charlie@example.com', 'hashed_password_3');


INSERT INTO user_role (user_id, role_id) VALUES
(1001, 1), -- Alice is a CUSTOMER
(1002, 2), -- Bob is an AGENT
(1003, 3); -- Charlie is an ADMIN


INSERT INTO tickets (ticket_id, customer_id, agent_id, subject, description, status, priority) VALUES
(5001, 1001, 1002, 'Cannot access account', 'I forgot my password and cannot reset.', 'OPEN', 'HIGH'),
(5002, 1001, NULL, 'Feature request', 'Add dark mode to dashboard.', 'OPEN', 'LOW');


INSERT INTO comments (comment_id, ticket_id, user_id, content, is_internal) VALUES
(7001, 5001, 1002, 'Working on resetting your password.', TRUE),
(7002, 5001, 1001, 'Thanks for the quick reply!', FALSE);


INSERT INTO attachments (attachment_id, ticket_id, file_path) VALUES
(8001, 5001, '/uploads/screenshots/error_5001.png');


INSERT INTO notifications (notification_id, user_id, ticket_id, message) VALUES
(9001, 1001, 5001, 'Your ticket has been assigned to an agent.'),
(9002, 1002, 5001, 'You have been assigned a new ticket.');


INSERT INTO ticket_reminders (reminder_id, ticket_id, reminder_time, message) VALUES
(6001, 5001, NOW() + INTERVAL 1 day, 'Follow up with the customer on password reset.');


INSERT INTO feedback (feedback_id, ticket_id, rating, comment) VALUES
(3001, 5001, 5, 'Great support, fast and helpful!');
