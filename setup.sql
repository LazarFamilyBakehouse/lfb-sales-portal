-- ============================================
-- SALES LEADS PORTAL — Supabase Setup
-- Lazar Family Bakehouse
-- ============================================
-- Run this in your Supabase SQL Editor:
--   Dashboard > SQL Editor > New Query > Paste > Run
-- ============================================

-- 1. Create the leads table
CREATE TABLE IF NOT EXISTS leads (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name        TEXT        NOT NULL,
  company     TEXT        DEFAULT '',
  email       TEXT        DEFAULT '',
  phone       TEXT        DEFAULT '',
  status      TEXT        NOT NULL DEFAULT 'Scouting'
                          CHECK (status IN ('Converted', 'Hot Lead', 'Scouting')),
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- 2. Index on status for fast segment filtering
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads (status);

-- 3. Auto-update the updated_at timestamp on edits
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_leads_updated_at ON leads;
CREATE TRIGGER trg_leads_updated_at
  BEFORE UPDATE ON leads
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- 4. Enable Row Level Security (RLS)
--    Only authenticated users can access the data
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users full access" ON leads
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- 5. Seed sample data (optional - delete if not needed)
INSERT INTO leads (name, company, email, phone, status) VALUES
  ('Maria Gonzalez',   'Metro Grocers',      'maria@metrogrocers.com',     '(555) 201-4432', 'Converted'),
  ('James Carter',     'Sunrise Cafe',        'james@sunrisecafe.com',      '(555) 318-9971', 'Hot Lead'),
  ('Aisha Patel',      'GreenLeaf Co-op',     'aisha@greenleafcoop.com',    '(555) 427-5518', 'Scouting'),
  ('Liam OBrien',      'Harbor Bistro',       'liam@harborbistro.com',      '(555) 534-6623', 'Hot Lead'),
  ('Yuki Tanaka',      'Peak Provisions',     'yuki@peakprovisions.com',    '(555) 642-3307', 'Scouting'),
  ('Sofia Rossi',      'Blue Sky Catering',   'sofia@blueskycatering.com',  '(555) 753-8841', 'Converted'),
  ('David Kim',        'Eastside Deli',       'david@eastsidedeli.com',     '(555) 861-2256', 'Scouting'),
  ('Fatima Al-Rashid', 'Golden Gate Foods',   'fatima@goldengate.com',      '(555) 974-1190', 'Hot Lead'),
  ('Ethan Brooks',     'Maple Street Market', 'ethan@maplestreet.com',      '(555) 185-7764', 'Scouting'),
  ('Priya Sharma',     'Cedar and Pine',      'priya@cedarandpine.com',     '(555) 296-4438', 'Converted');
