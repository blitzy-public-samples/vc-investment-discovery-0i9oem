-- Seed data for users table
INSERT INTO users (email, password, first_name, last_name, date_joined, preferences) VALUES
('john.doe@example.com', '$2a$10$xJwL3Vr8UGZzDzZzs8Xz9.8qZ6k5Z5Xz5Xz5Xz5Xz5Xz5Xz5Xz5X', 'John', 'Doe', CURRENT_TIMESTAMP, '{"theme": "light", "notificationSettings": {"email": true, "push": true}, "defaultCurrency": "USD", "language": "en"}'),
('jane.smith@example.com', '$2a$10$xJwL3Vr8UGZzDzZzs8Xz9.8qZ6k5Z5Xz5Xz5Xz5Xz5Xz5Xz5Xz5X', 'Jane', 'Smith', CURRENT_TIMESTAMP, '{"theme": "dark", "notificationSettings": {"email": false, "push": true}, "defaultCurrency": "EUR", "language": "fr"}'),
('alice.johnson@example.com', '$2a$10$xJwL3Vr8UGZzDzZzs8Xz9.8qZ6k5Z5Xz5Xz5Xz5Xz5Xz5Xz5Xz5X', 'Alice', 'Johnson', CURRENT_TIMESTAMP, '{"theme": "light", "notificationSettings": {"email": true, "push": false}, "defaultCurrency": "GBP", "language": "en"}'),
('bob.williams@example.com', '$2a$10$xJwL3Vr8UGZzDzZzs8Xz9.8qZ6k5Z5Xz5Xz5Xz5Xz5Xz5Xz5Xz5X', 'Bob', 'Williams', CURRENT_TIMESTAMP, '{"theme": "dark", "notificationSettings": {"email": true, "push": true}, "defaultCurrency": "USD", "language": "es"}'),
('emma.brown@example.com', '$2a$10$xJwL3Vr8UGZzDzZzs8Xz9.8qZ6k5Z5Xz5Xz5Xz5Xz5Xz5Xz5Xz5X', 'Emma', 'Brown', CURRENT_TIMESTAMP, '{"theme": "light", "notificationSettings": {"email": false, "push": false}, "defaultCurrency": "JPY", "language": "ja"}');

-- Set the sequence for user IDs to start after the seeded data
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));