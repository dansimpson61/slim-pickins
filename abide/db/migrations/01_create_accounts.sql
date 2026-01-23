CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL -- 'asset', 'liability', 'income', 'expense', 'external'
);

-- Seed defaults
INSERT OR IGNORE INTO accounts (id, name, type) VALUES (1, 'Main Portfolio', 'asset');
INSERT OR IGNORE INTO accounts (id, name, type) VALUES (2, 'External', 'external');
