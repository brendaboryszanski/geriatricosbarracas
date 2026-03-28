-- Ejecutar en el SQL Editor de Supabase
-- https://supabase.com/dashboard -> SQL Editor

-- Slider (hero carousel)
create table slider (
  id bigint primary key generated always as identity,
  image_url text not null,
  caption text not null default '',
  "order" int not null default 0
);

-- Residences
create table residences (
  id bigint primary key generated always as identity,
  name text not null,
  address text not null default '',
  phone text not null default '',
  description text not null default '',
  amenities jsonb not null default '[]'
);

-- Services
create table services (
  id bigint primary key generated always as identity,
  title text not null,
  description text not null default '',
  "order" int not null default 0
);

-- Activities
create table activities (
  id bigint primary key generated always as identity,
  title text not null,
  description text not null default '',
  image_url text not null default '',
  "order" int not null default 0
);

-- Gallery
create table gallery (
  id bigint primary key generated always as identity,
  title text not null default '',
  image_url text not null,
  category text not null check (category in ('Momentos', 'Lesa', 'Rincon'))
);

-- Team
create table team (
  id bigint primary key generated always as identity,
  name text not null,
  role text not null default '',
  photo_url text not null default '',
  bio text not null default '',
  is_owner boolean not null default false,
  "order" int not null default 0
);

-- Objectives
create table objectives (
  id bigint primary key generated always as identity,
  target text not null check (target in ('residentes', 'familiares')),
  title text not null,
  description text not null default ''
);

-- Contact key-value store
create table contact (
  id bigint primary key generated always as identity,
  key text not null unique,
  value text not null default ''
);

-- Storage bucket (ejecutar desde el dashboard o via API)
-- Crear bucket llamado "images" con acceso público

-- Habilitar RLS y políticas de acceso público para lectura
alter table slider enable row level security;
alter table residences enable row level security;
alter table services enable row level security;
alter table activities enable row level security;
alter table gallery enable row level security;
alter table team enable row level security;
alter table objectives enable row level security;
alter table contact enable row level security;

-- Lectura pública para todas las tablas
create policy "public read" on slider for select using (true);
create policy "public read" on residences for select using (true);
create policy "public read" on services for select using (true);
create policy "public read" on activities for select using (true);
create policy "public read" on gallery for select using (true);
create policy "public read" on team for select using (true);
create policy "public read" on objectives for select using (true);
create policy "public read" on contact for select using (true);

-- Escritura solo para usuarios autenticados
create policy "auth write" on slider for all using (auth.role() = 'authenticated');
create policy "auth write" on residences for all using (auth.role() = 'authenticated');
create policy "auth write" on services for all using (auth.role() = 'authenticated');
create policy "auth write" on activities for all using (auth.role() = 'authenticated');
create policy "auth write" on gallery for all using (auth.role() = 'authenticated');
create policy "auth write" on team for all using (auth.role() = 'authenticated');
create policy "auth write" on objectives for all using (auth.role() = 'authenticated');
create policy "auth write" on contact for all using (auth.role() = 'authenticated');

-- =============================================
-- DATOS INICIALES (copiar del sitio actual)
-- =============================================

insert into slider (image_url, caption, "order") values
  ('/images/slider/3.jpg', '2 residencias para mejorar la vida de nuestros mayores', 1),
  ('/images/slider/0.jpg', 'Donde se encuentran nuevos motivos y deseos de aprender', 2),
  ('/images/slider/1.jpg', 'Garantizando la calidad de vida', 3),
  ('/images/slider/2.jpg', 'Buscando que los residentes se sientan como en su casa', 4);

insert into residences (name, address, phone, description, amenities) values
  ('Rincón del Sur', 'Iriarte 1756, Barracas, Capital Federal', '+54 9 11 3447-8263',
   'Residencia moderna ubicada en planta baja y primer piso con habitaciones dobles y triples. Espacios amplios y cálidos pensados para el bienestar de cada residente.',
   '["Calefacción central", "Placares amplios", "Llamadores inalámbricos de emergencia", "Televisor plasma", "Patio jardín", "Aire acondicionado", "Wi-Fi", "Videovigilancia"]'),
  ('Le-Sa', 'California 2578, Capital Federal', '4301-7992',
   'Residencia distribuida en dos plantas con comedores y espacios comunes. Cuenta con patio jardín, terraza y todas las comodidades para una vida cómoda y segura.',
   '["Calefacción central", "Placares amplios", "Llamadores inalámbricos de emergencia", "Patio jardín", "Terraza", "Aire acondicionado", "Wi-Fi", "Videovigilancia"]');

insert into services (title, description, "order") values
  ('Atención médica', 'Médico geriatra de planta permanente y servicio médico de emergencia. Asistentes geriátricas y enfermeras con formación permanente y experiencia acreditada.', 1),
  ('Evaluación neurocognitiva', 'Evaluación neurocognitiva a cargo de una psicóloga especializada en gerontología.', 2),
  ('Alimentación personalizada', 'Nutricionista con controles periódicos de peso y planificación de dietas. Alimentación especial según cada caso.', 3),
  ('Atención kinesiológica', 'Evaluación individual, rehabilitación con equipamiento especializado y gimnasio.', 4),
  ('Asistentes geriátricas', 'Asistentes geriátricas y enfermeras con formación permanente y experiencia acreditada.', 5),
  ('Titulares de las instituciones', 'Los dueños forman parte del personal profesional y están presentes en el día a día de ambas residencias.', 6);

insert into activities (title, description, image_url, "order") values
  ('Fiestas con familiares', 'Celebramos los momentos importantes junto a las familias, fomentando el vínculo y la alegría compartida.', '/images/activities/fiesta.jpg', 1),
  ('Espectáculos', 'Contratación de espectáculos de teatro, música y arte para enriquecer la vida cultural de los residentes.', '/images/activities/espectaculos.png', 2),
  ('Talleres', 'Estimulación cognitiva, musicoterapia, gimnasia, arte y actividades recreativas para el bienestar integral.', '/images/activities/talleres.png', 3);

insert into team (name, role, photo_url, bio, is_owner, "order") values
  ('Lic. Marcela Yudewitz', 'Coordinadora General · Lic. en Psicopedagogía · Especialista en Psicogerontología', '/images/team/marcela.jpg', 'Coordinadora general de ambas residencias. Licenciada en Psicopedagogía y especialista en Psicogerontología, realiza el seguimiento integral de cada residente asegurando una atención personalizada y de calidad.', true, 1),
  ('Dr. Julio Boryszanski', 'Director Médico · Médico Clínico · Especialista en Geriatría', '/images/team/juliobor.jpg', 'Director médico de las residencias. Médico clínico y especialista en Geriatría, a cargo de la atención médica permanente y la supervisión del equipo de salud.', true, 2),
  ('Natali Muniz Bravo', 'Taller de Arte Recreativo', '/images/team/natali.jpeg', 'Coordinadora del taller de arte recreativo, donde los residentes expresan su creatividad y comparten momentos de alegría.', false, 3),
  ('Agustina Manikis', 'Musicoterapeuta', '/images/team/Musicoterapeuta.jpeg', 'Licenciada en Musicoterapia. Trabaja la estimulación cognitiva, emocional y social a través de la música.', false, 4),
  ('Luciana', 'Licenciada en Psicología', '/images/team/luciana.jpeg', 'Psicóloga del equipo, brinda acompañamiento emocional y seguimiento del bienestar de residentes y familias.', false, 5),
  ('Julián Pompei', 'Kinesiólogo', '/images/team/kinesiologo.jpg', 'Realiza evaluación individual y rehabilitación kinesiológica con equipamiento especializado y actividades en el gimnasio.', false, 6),
  ('Gladys', 'Nutricionista', '/images/team/nutri.jpeg', 'Nutricionista a cargo del plan alimentario, con controles periódicos y dietas adaptadas a las necesidades de cada residente.', false, 7),
  ('Daniel', 'Psicomotricista · Prof. de Gimnasia · Asistente Gerontológico', '/images/team/profgym.jpeg', 'Psicomotricista, profesor de gimnasia y psicólogo social. Trabaja el movimiento, el equilibrio y la autonomía de los residentes.', false, 8);

insert into objectives (target, title, description) values
  ('residentes', 'Para nuestros residentes', 'Buscamos que cada residente se sienta como en su casa, encontrando nuevos motivos y deseos de aprender, compartir y disfrutar cada día.'),
  ('familiares', 'Para las familias', 'Ofrecemos un espacio de confianza para las familias, con horarios de visita flexibles de acuerdo a la Ley 1710 y comunicación permanente sobre el bienestar de su familiar.');

insert into contact (key, value) values
  ('email', 'info@geriatricosbarracas.com.ar'),
  ('map_url', 'https://www.google.com/maps/d/embed?mid=1NSHPNUCM_HlZazYXqJx_oLeIXD0ifUd8&hl=es'),
  ('footer_text', 'Residencias para adultos mayores · Barracas, Capital Federal');
