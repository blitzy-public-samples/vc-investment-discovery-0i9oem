-- Seed data for companies table
INSERT INTO companies (name, industry, founding_date, description, headquarters, website, valuation, employee_count, founders, stage, financial_data, social_data, market_data) VALUES
('TechNova', 'Technology', '2018-03-15', 'Innovative AI-driven software solutions', 'San Francisco, CA', 'https://technova.example.com', 50000000, 75, ARRAY['John Smith', 'Emily Chen'], 'SCALING', 
 '{"revenue": 5000000, "profit": -1000000, "burn_rate": 300000, "funding_rounds": [{"date": "2019-01-01", "amount": 2000000, "valuation": 10000000}, {"date": "2020-06-01", "amount": 10000000, "valuation": 50000000}]}',
 '{"twitter_followers": 15000, "linkedin_followers": 5000, "web_traffic": 100000, "sentiment_score": 0.75}',
 '{"market_size": 5000000000, "competitor_count": 12, "market_growth_rate": 0.15, "market_share": 0.01}'),

('GreenEco Solutions', 'CleanTech', '2017-09-01', 'Sustainable energy storage systems', 'Berlin, Germany', 'https://greeneco.example.com', 30000000, 50, ARRAY['Laura Mueller', 'Alex Bergmann'], 'EARLY_TRACTION',
 '{"revenue": 2000000, "profit": -1500000, "burn_rate": 200000, "funding_rounds": [{"date": "2018-03-01", "amount": 1000000, "valuation": 5000000}, {"date": "2019-11-01", "amount": 5000000, "valuation": 30000000}]}',
 '{"twitter_followers": 8000, "linkedin_followers": 3000, "web_traffic": 50000, "sentiment_score": 0.82}',
 '{"market_size": 2000000000, "competitor_count": 8, "market_growth_rate": 0.22, "market_share": 0.005}'),

('HealthPlus', 'HealthTech', '2019-11-20', 'AI-powered personalized health monitoring', 'Boston, MA', 'https://healthplus.example.com', 20000000, 30, ARRAY['Sarah Johnson', 'David Lee'], 'SERIES_A',
 '{"revenue": 1000000, "profit": -2000000, "burn_rate": 250000, "funding_rounds": [{"date": "2020-05-01", "amount": 3000000, "valuation": 15000000}, {"date": "2021-02-01", "amount": 7000000, "valuation": 20000000}]}',
 '{"twitter_followers": 5000, "linkedin_followers": 2000, "web_traffic": 75000, "sentiment_score": 0.68}',
 '{"market_size": 10000000000, "competitor_count": 20, "market_growth_rate": 0.18, "market_share": 0.002}'),

('FinSecure', 'FinTech', '2020-01-10', 'Blockchain-based secure financial transactions', 'London, UK', 'https://finsecure.example.com', 15000000, 25, ARRAY['Michael Brown', 'Sophie Taylor'], 'SEED',
 '{"revenue": 500000, "profit": -1000000, "burn_rate": 150000, "funding_rounds": [{"date": "2020-07-01", "amount": 2000000, "valuation": 10000000}]}',
 '{"twitter_followers": 3000, "linkedin_followers": 1500, "web_traffic": 30000, "sentiment_score": 0.71}',
 '{"market_size": 8000000000, "competitor_count": 15, "market_growth_rate": 0.25, "market_share": 0.001}'),

('EduTech Innovations', 'EdTech', '2018-06-05', 'Virtual reality educational platforms', 'Toronto, Canada', 'https://edutech.example.com', 25000000, 40, ARRAY['Robert Chang', 'Maria Garcia'], 'SERIES_B',
 '{"revenue": 3000000, "profit": -500000, "burn_rate": 180000, "funding_rounds": [{"date": "2019-02-01", "amount": 1500000, "valuation": 8000000}, {"date": "2020-09-01", "amount": 6000000, "valuation": 25000000}]}',
 '{"twitter_followers": 10000, "linkedin_followers": 4000, "web_traffic": 80000, "sentiment_score": 0.79}',
 '{"market_size": 3000000000, "competitor_count": 10, "market_growth_rate": 0.20, "market_share": 0.008}');

-- Set the sequence for company IDs to start after the seeded data
SELECT setval('companies_id_seq', (SELECT MAX(id) FROM companies));