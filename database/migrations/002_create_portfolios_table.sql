CREATE TABLE portfolios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    creation_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    user_id UUID NOT NULL,
    total_value DECIMAL(15, 2) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_portfolios_user_id ON portfolios(user_id);

COMMENT ON TABLE portfolios IS 'Stores portfolio information for users';
COMMENT ON COLUMN portfolios.id IS 'Unique identifier for the portfolio';
COMMENT ON COLUMN portfolios.name IS 'Name of the portfolio';
COMMENT ON COLUMN portfolios.creation_date IS 'Date and time when the portfolio was created';
COMMENT ON COLUMN portfolios.user_id IS 'Foreign key referencing the user who owns this portfolio';
COMMENT ON COLUMN portfolios.total_value IS 'Total value of all investments in the portfolio';