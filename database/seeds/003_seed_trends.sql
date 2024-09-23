-- Seed data for trends table
INSERT INTO trends (name, description, category, identified_date, growth_rate, confidence_score, related_industries, related_company_ids, keywords, data) VALUES
('Artificial Intelligence in Healthcare', 'AI applications for diagnosis and treatment in healthcare', 'TECHNOLOGY', '2023-01-15', 0.35, 85, ARRAY['HealthTech', 'AI'], ARRAY[(SELECT id FROM companies WHERE name = 'HealthPlus')], ARRAY['AI', 'healthcare', 'diagnosis', 'treatment'], 
 '{"market_size": 10000000000, "adoption_rate": 0.15, "key_players": ["IBM Watson Health", "Google Health", "Microsoft Healthcare"]}'),

('Sustainable Energy Storage', 'Advancements in energy storage for renewable sources', 'TECHNOLOGY', '2023-02-01', 0.28, 80, ARRAY['CleanTech', 'Energy'], ARRAY[(SELECT id FROM companies WHERE name = 'GreenEco Solutions')], ARRAY['energy storage', 'renewable energy', 'sustainability'], 
 '{"market_size": 5000000000, "adoption_rate": 0.12, "key_players": ["Tesla", "LG Chem", "Panasonic"]}'),

('Decentralized Finance (DeFi)', 'Blockchain-based financial services and products', 'MARKET', '2023-02-15', 0.40, 75, ARRAY['FinTech', 'Blockchain'], ARRAY[(SELECT id FROM companies WHERE name = 'FinSecure')], ARRAY['DeFi', 'blockchain', 'cryptocurrency', 'finance'], 
 '{"market_size": 8000000000, "adoption_rate": 0.08, "key_players": ["Uniswap", "Aave", "Compound"]}'),

('Remote Work Technologies', 'Tools and platforms enabling efficient remote work', 'TECHNOLOGY', '2023-03-01', 0.25, 90, ARRAY['SaaS', 'Productivity'], ARRAY[(SELECT id FROM companies WHERE name = 'TechNova')], ARRAY['remote work', 'collaboration', 'productivity'], 
 '{"market_size": 20000000000, "adoption_rate": 0.30, "key_players": ["Zoom", "Slack", "Microsoft Teams"]}'),

('EdTech Gamification', 'Gamification techniques in educational technology', 'TECHNOLOGY', '2023-03-15', 0.30, 78, ARRAY['EdTech', 'Gaming'], ARRAY[(SELECT id FROM companies WHERE name = 'EduTech Innovations')], ARRAY['edtech', 'gamification', 'e-learning'], 
 '{"market_size": 3000000000, "adoption_rate": 0.18, "key_players": ["Duolingo", "Kahoot!", "Coursera"]}');

-- Set the sequence for trend IDs to start after the seeded data
SELECT setval('trends_id_seq', (SELECT MAX(id) FROM trends));