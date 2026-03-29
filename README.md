# geriatricosbarracas.com.ar

Sitio web de Geriátricos Barracas (residencias Le-Sa y Rincón del Sur). Originalmente un sitio estático PHP + Bootstrap 2, migrado a Astro + Supabase con panel de administración.

## Stack

- **Framework**: [Astro](https://astro.build/) (SSR, `output: 'server'`)
- **Base de datos**: [Supabase](https://supabase.com/) (PostgreSQL + Auth + Storage)
- **Hosting**: [Vercel](https://vercel.com/)
- **Estilos**: Tailwind CSS
- **Otros**: Swiper (carousel), SortableJS (drag-and-drop en admin)

## Estructura del proyecto

```
src/
├── pages/
│   ├── index.astro              # Página pública (landing, una sola página)
│   └── admin/
│       ├── login.astro          # Login con Supabase Auth
│       ├── logout.ts            # Cierra sesión (borra cookies)
│       ├── index.astro          # Dashboard admin
│       ├── slider.astro         # CRUD slides del hero
│       ├── residencias.astro    # Editar residencias y amenities
│       ├── servicios.astro      # CRUD servicios
│       ├── actividades.astro    # CRUD actividades
│       ├── galeria.astro        # CRUD galería de fotos
│       ├── equipo.astro         # CRUD equipo/staff
│       ├── objetivos.astro      # Editar objetivos
│       ├── faqs.astro           # CRUD preguntas frecuentes
│       └── contacto.astro       # Editar datos de contacto
├── components/
│   ├── Navbar.astro
│   ├── HeroSlider.astro
│   ├── ResidenceCards.astro
│   ├── ServicesGrid.astro
│   ├── ActivitiesSection.astro
│   ├── GallerySection.astro
│   ├── TeamSection.astro
│   ├── ObjectivesSection.astro
│   ├── FaqsSection.astro
│   ├── ReviewsSection.astro
│   ├── ContactSection.astro
│   ├── FloatingButtons.astro
│   └── Footer.astro
├── layouts/
│   ├── Layout.astro             # Layout público
│   └── AdminLayout.astro        # Layout del panel admin
├── lib/
│   ├── supabase.ts              # Clientes Supabase (anon + admin)
│   └── utils.ts                 # Utilidades (optimización de imágenes)
├── styles/
│   └── global.css
├── middleware.ts                 # Protege rutas /admin/* con auth
├── locals.d.ts
└── env.d.ts

db/
└── schema.sql                   # Schema completo de la base (referencia)
```

## Base de datos

10 tablas en Supabase, todas con RLS habilitado (lectura pública, escritura solo autenticados):

| Tabla | Descripción |
|---|---|
| `slider` | Imágenes del carousel hero |
| `residences` | Las 2 residencias (nombre, dirección, teléfono, amenities) |
| `services` | Servicios ofrecidos (con ícono emoji) |
| `activities` | Actividades recreativas |
| `gallery` | Fotos de la galería (por categoría, residencia y subcategoría) |
| `gallery_subcategories` | Lookup de subcategorías para galería |
| `team` | Equipo / staff |
| `objectives` | Objetivos (para residentes y familiares) |
| `contact` | Datos de contacto (key-value: email, mapa, footer) |
| `faqs` | Preguntas frecuentes |

El schema completo está en `db/schema.sql`.

**Storage**: Bucket `images` en Supabase Storage con carpetas `slider/`, `gallery/`, `activities/`, `team/`.

## Panel de administración (`/admin`)

### Autenticación

- Login con email/password via Supabase Auth (`/admin/login`)
- El middleware (`src/middleware.ts`) protege todas las rutas `/admin/*` excepto `/admin/login`
- Las sesiones se manejan con cookies httpOnly (`sb-access-token`, `sb-refresh-token`)
- Para las operaciones de escritura se usa el cliente `supabaseAdmin` (service role key) que bypasea RLS

### Funcionalidades

Cada sección del sitio tiene su página admin con:

- **Agregar / editar / eliminar** contenido (formularios con POST)
- **Reordenar** con drag-and-drop (SortableJS) en: servicios, actividades, equipo, FAQs
- **Subir imágenes** a Supabase Storage en: slider, actividades, galería, equipo

### Acceso

1. Ir a `/admin/login`
2. Ingresar con las credenciales configuradas en Supabase Auth
3. El dashboard (`/admin`) muestra links a cada sección

## Desarrollo local

```bash
npm install
npm run dev
```

Requiere un archivo `.env` con:

```
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
GOOGLE_PLACES_API_KEY=AIza...
```

Ver `.env.example` como referencia.

## Deploy

Push a `main` → Vercel hace build y deploy automático.
