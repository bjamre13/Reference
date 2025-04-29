
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
INSERT INTO users (username, email, password) VALUES 
('admin_user', 'admin@example.com', 'admin123'),
('agent_john', 'john.agent@example.com', 'agent123'),
('customer_mary', 'mary.customer@example.com', 'customer123'),
('customer_steve', 'steve.customer@example.com', 'customer123');

-- Assign roles to users
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1), -- admin_user -> ADMIN
(2, 2), -- agent_john -> AGENT
(3, 3), -- customer_mary -> CUSTOMER
(4, 3); -- customer_steve -> CUSTOMER

-- Insert tickets
INSERT INTO tickets (title, description, status, priority, created_by_id, assigned_to_id) VALUES 
('Login issue', 'Cannot log into the account, please assist.', 'OPEN', 'HIGH', 3, 2),
('Feature request', 'Requesting a new feature to export reports.', 'IN_PROGRESS', 'MEDIUM', 4, 2),
('Password reset', 'Forgot password, need reset.', 'RESOLVED', 'LOW', 3, 2);

-- Insert ticket comments
INSERT INTO ticket_comments (content, user_id, ticket_id) VALUES
('Looking into the login issue.', 2, 1),
('Please provide more details about the feature.', 2, 2),
('Password reset instructions sent.', 2, 3),
('Thanks for the quick response.', 3, 3);
