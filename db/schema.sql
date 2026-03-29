-- ==============================================
-- Geriátricos Barracas — Schema completo
-- Refleja el estado real de la base en Supabase
-- Última actualización: 2026-03-28
-- ==============================================

-- Slider (hero carousel)
create table slider (
  id bigint primary key generated always as identity,
  image_url text not null,
  caption text not null default '',
  "order" int not null default 0
);

-- Residencias
create table residences (
  id bigint primary key generated always as identity,
  name text not null,
  address text not null default '',
  phone text not null default '',
  description text not null default '',
  amenities jsonb not null default '[]'
);

-- Servicios
create table services (
  id bigint primary key generated always as identity,
  title text not null,
  description text not null default '',
  "order" int not null default 0,
  icon text
);

-- Actividades
create table activities (
  id bigint primary key generated always as identity,
  title text not null,
  description text not null default '',
  image_url text not null default '',
  "order" int not null default 0
);

-- Galería de fotos
create table gallery (
  id bigint primary key generated always as identity,
  title text not null default '',
  image_url text not null,
  category text not null check (category in ('Momentos', 'Lesa', 'Rincon')),
  residence text not null default 'Ambas',
  subcategory text not null default 'Otros'
);

-- Subcategorías de galería (lookup table)
create table gallery_subcategories (
  id bigint primary key generated always as identity,
  name text not null unique
);

-- Equipo
create table team (
  id bigint primary key generated always as identity,
  name text not null,
  role text not null default '',
  photo_url text not null default '',
  bio text not null default '',
  is_owner boolean not null default false,
  "order" int not null default 0
);

-- Objetivos
create table objectives (
  id bigint primary key generated always as identity,
  target text not null check (target in ('residentes', 'familiares')),
  title text not null,
  description text not null default ''
);

-- Contacto (key-value)
create table contact (
  id bigint primary key generated always as identity,
  key text not null unique,
  value text not null default ''
);

-- FAQs
create table faqs (
  id bigint primary key generated always as identity,
  question text not null,
  answer text not null,
  "order" int not null default 99,
  created_at timestamptz default now()
);

-- ==============================================
-- RLS + Políticas
-- ==============================================

alter table slider enable row level security;
alter table residences enable row level security;
alter table services enable row level security;
alter table activities enable row level security;
alter table gallery enable row level security;
alter table gallery_subcategories enable row level security;
alter table team enable row level security;
alter table objectives enable row level security;
alter table contact enable row level security;
alter table faqs enable row level security;

-- Lectura pública
create policy "public read" on slider for select using (true);
create policy "public read" on residences for select using (true);
create policy "public read" on services for select using (true);
create policy "public read" on activities for select using (true);
create policy "public read" on gallery for select using (true);
create policy "public read" on team for select using (true);
create policy "public read" on objectives for select using (true);
create policy "public read" on contact for select using (true);
create policy "public read" on faqs for select using (true);

-- gallery_subcategories: lectura pública, escritura abierta (admin usa service role)
create policy "gc_select" on gallery_subcategories for select using (true);
create policy "gc_insert" on gallery_subcategories for insert with check (true);
create policy "gc_delete" on gallery_subcategories for delete using (true);

-- Escritura solo para usuarios autenticados
create policy "auth write" on slider for all using (auth.role() = 'authenticated');
create policy "auth write" on residences for all using (auth.role() = 'authenticated');
create policy "auth write" on services for all using (auth.role() = 'authenticated');
create policy "auth write" on activities for all using (auth.role() = 'authenticated');
create policy "auth write" on gallery for all using (auth.role() = 'authenticated');
create policy "auth write" on team for all using (auth.role() = 'authenticated');
create policy "auth write" on objectives for all using (auth.role() = 'authenticated');
create policy "auth write" on contact for all using (auth.role() = 'authenticated');
create policy "auth write" on faqs for all using (auth.role() = 'authenticated');

-- ==============================================
-- Storage: crear bucket "images" con acceso público
-- (hacer desde el dashboard de Supabase)
-- ==============================================
