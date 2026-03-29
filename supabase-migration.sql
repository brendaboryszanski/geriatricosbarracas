-- Migration: add icon column to services, create faqs table
-- Run this in the Supabase SQL Editor

-- Add icon field to services (emoji)
ALTER TABLE services ADD COLUMN IF NOT EXISTS icon text;

-- Create FAQs table
CREATE TABLE IF NOT EXISTS faqs (
  id bigint generated always as identity primary key,
  question text not null,
  answer text not null,
  "order" integer not null default 99,
  created_at timestamptz default now()
);

-- RLS for faqs
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read faqs" ON faqs
  FOR SELECT USING (true);

CREATE POLICY "Authenticated write faqs" ON faqs
  FOR ALL USING (auth.role() = 'authenticated');
