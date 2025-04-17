-- Create public schema if not exists
CREATE SCHEMA IF NOT EXISTS public;

-- Create roles table
CREATE TABLE IF NOT EXISTS public.roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Create tenants table
CREATE TABLE IF NOT EXISTS public.tenants (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    schema VARCHAR(50) NOT NULL UNIQUE
);

-- Insert default roles
INSERT INTO public.roles (name) VALUES ('ROLE_ADMIN')
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.roles (name) VALUES ('ROLE_USER')
ON CONFLICT (name) DO NOTHING; 