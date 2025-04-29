
// database creation

CREATE DATABASE customer_support_ticket_system;
USE customer_support_ticket_system;


// tables

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name ENUM('ADMIN', 'AGENT', 'CUSTOMER') NOT NULL UNIQUE
);

CREATE TABLE user_roles (
    user_id BIGINT,
    role_id BIGINT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE tickets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'OPEN',
    priority ENUM('LOW', 'MEDIUM', 'HIGH') DEFAULT 'MEDIUM',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by_id BIGINT,
    assigned_to_id BIGINT,
    FOREIGN KEY (created_by_id) REFERENCES users(id),
    FOREIGN KEY (assigned_to_id) REFERENCES users(id)
);

CREATE TABLE ticket_comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id BIGINT,
    ticket_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (ticket_id) REFERENCES tickets(id)
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