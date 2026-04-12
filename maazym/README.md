# Maazym - Restaurant Management System

A comprehensive, dual-language (Arabic/English) restaurant management system built with Next.js and Supabase.

## Features

### Core Modules
- **Recipe Book** - Manage recipes with ingredients, cost calculation, calorie tracking, and image uploads
- **Stock Inventory** - Full inventory management with zero-stock alerts, daily consumption tracking, and stock summaries
- **Menu Management** - Link recipes to menu items with pricing, profit margin calculation, and availability toggles
- **Supplier Management** - Track suppliers, link to inventory items, compare pricing
- **Purchase Orders** - Create, track, and receive purchase orders with auto stock updates
- **Waste Tracking** - Log waste with reasons, auto-deduct from stock, cost analysis
- **Promotions & Pricing** - Cost calculator, what-if simulator, item comparison, and promotion management
- **Reports & Analytics** - Daily summaries, cost analysis, profitability charts, consumption trends

### System Features
- Dual language: Arabic (RTL, primary) and English
- Role-based access: Admin, Manager, Kitchen Chef, Bar Tender
- Multi-branch ready architecture
- Halal compliance enforcement at database level
- Real-time stock alerts
- Responsive design for desktop and mobile

## Tech Stack

- **Frontend:** Next.js 16 (App Router), TypeScript, Tailwind CSS v4, shadcn/ui
- **Backend:** Supabase (PostgreSQL, Auth, Storage, RLS)
- **i18n:** next-intl (Arabic RTL + English LTR)
- **Charts:** Recharts
- **Forms:** React Hook Form + Zod
- **Icons:** Lucide React

## Getting Started

### Prerequisites
- Node.js 18+
- A Supabase project ([create one here](https://supabase.com))

### Setup

1. **Clone and install dependencies:**
   ```bash
   cd maazym
   npm install
   ```

2. **Configure environment variables:**
   
   Edit `.env.local` and add your Supabase credentials:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   ```

3. **Set up the database:**
   
   Run the migration in your Supabase SQL Editor:
   - Open `supabase/migrations/00001_initial_schema.sql` and execute it
   - Then run `supabase/seed.sql` to populate initial categories and configuration

4. **Create a Supabase Storage bucket:**
   - Create a bucket named `recipe-images` (public)

5. **Create the first admin user:**
   - Go to Supabase Dashboard > Authentication > Users > Add User
   - After creating the user, update their profile in the `profiles` table:
     ```sql
     UPDATE profiles 
     SET role = 'admin', 
         full_name = 'Admin',
         branch_id = '00000000-0000-0000-0000-000000000001'
     WHERE id = 'your-user-uuid';
     ```

6. **Start the development server:**
   ```bash
   npm run dev
   ```

7. **Open the app:**
   
   Navigate to [http://localhost:3000](http://localhost:3000)

## Project Structure

```
src/
  app/
    [locale]/
      (auth)/login/         - Login page
      (dashboard)/           - All dashboard pages
        recipes/             - Recipe management
        inventory/           - Stock management
        menu/                - Menu management
        suppliers/           - Supplier management
        purchase-orders/     - Purchase order management
        waste/               - Waste tracking
        promotions/          - Promotions & pricing tools
        reports/             - Reports & analytics
        settings/            - System settings
  components/
    ui/                      - shadcn/ui components
    layout/                  - Sidebar, header, language toggle
    recipes/                 - Recipe-specific components
    promotions/              - Promotions sub-navigation
  lib/
    supabase/                - Supabase client configuration
    i18n/                    - Internationalization config
    pricing/                 - Pricing calculation utilities
  hooks/                     - Custom React hooks
  types/                     - TypeScript type definitions
  messages/                  - Translation files (ar.json, en.json)
supabase/
  migrations/                - Database migrations
  seed.sql                   - Initial seed data
```

## User Roles

| Role | Access |
|------|--------|
| Admin | Full system access including user management |
| Manager | All modules except user management |
| Kitchen Chef | Recipes (own), daily consumption, waste logging |
| Bar Tender | Recipes (bar), daily consumption, waste logging |

## License

Private - All rights reserved.
