CREATE TABLE IF NOT EXISTS portfolios (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS portfolio_accounts (
  portfolio_id INTEGER,
  account_id INTEGER,
  PRIMARY KEY (portfolio_id, account_id),
  FOREIGN KEY(portfolio_id) REFERENCES portfolios(id),
  FOREIGN KEY(account_id) REFERENCES accounts(id)
);

-- Seed Default "Main Portfolio" if not exists
INSERT OR IGNORE INTO portfolios (id, name) VALUES (1, 'Main Portfolio');

-- Link Default Main Portfolio (Account 1: Main Portfolio) to Portfolio 1
INSERT OR IGNORE INTO portfolio_accounts (portfolio_id, account_id) VALUES (1, 1);
