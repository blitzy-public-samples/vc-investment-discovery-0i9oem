CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    related_entity_id UUID,
    priority VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_alerts_user_id ON alerts(user_id);
CREATE INDEX idx_alerts_created_at ON alerts(created_at);
CREATE INDEX idx_alerts_is_read ON alerts(is_read);

COMMENT ON TABLE alerts IS 'Stores alert information for users';
COMMENT ON COLUMN alerts.id IS 'Unique identifier for the alert';
COMMENT ON COLUMN alerts.user_id IS 'Foreign key referencing the user who receives this alert';
COMMENT ON COLUMN alerts.type IS 'Type of the alert (e.g., INVESTMENT_OPPORTUNITY, PORTFOLIO_UPDATE)';
COMMENT ON COLUMN alerts.title IS 'Title of the alert';
COMMENT ON COLUMN alerts.message IS 'Detailed message of the alert';
COMMENT ON COLUMN alerts.created_at IS 'Timestamp when the alert was created';
COMMENT ON COLUMN alerts.is_read IS 'Boolean indicating whether the alert has been read by the user';
COMMENT ON COLUMN alerts.related_entity_id IS 'Optional UUID of a related entity (e.g., investment, company)';
COMMENT ON COLUMN alerts.priority IS 'Priority level of the alert (e.g., LOW, MEDIUM, HIGH, URGENT)';

-- Create an enumeration type for alert types
CREATE TYPE alert_type AS ENUM ('INVESTMENT_OPPORTUNITY', 'PORTFOLIO_UPDATE', 'MARKET_NEWS', 'COMPANY_MILESTONE', 'TREND_ALERT');

-- Create an enumeration type for alert priorities
CREATE TYPE alert_priority AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT');

-- Alter the alerts table to use the new enum types
ALTER TABLE alerts
    ALTER COLUMN type TYPE alert_type USING type::alert_type,
    ALTER COLUMN priority TYPE alert_priority USING priority::alert_priority;

-- Add a check constraint to ensure valid values for is_read
ALTER TABLE alerts
    ADD CONSTRAINT chk_alerts_is_read CHECK (is_read IN (TRUE, FALSE));