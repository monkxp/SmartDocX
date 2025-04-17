-- Function to create tenant schema and tables
CREATE OR REPLACE FUNCTION create_tenant_schema(tenant_schema VARCHAR)
RETURNS void AS $$
BEGIN
    -- Create tenant schema
    EXECUTE 'CREATE SCHEMA IF NOT EXISTS ' || quote_ident(tenant_schema);
    
    -- Create users table in tenant schema
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(tenant_schema) || '.users (
        id BIGSERIAL PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        tenant_id BIGINT NOT NULL REFERENCES public.tenants(id),
        role_id BIGINT NOT NULL REFERENCES public.roles(id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    )';
    
    -- Create index on username and email
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_' || quote_ident(tenant_schema) || '_users_username 
            ON ' || quote_ident(tenant_schema) || '.users(username)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_' || quote_ident(tenant_schema) || '_users_email 
            ON ' || quote_ident(tenant_schema) || '.users(email)';
END;
$$ LANGUAGE plpgsql;

-- Function to drop tenant schema
CREATE OR REPLACE FUNCTION drop_tenant_schema(tenant_schema VARCHAR)
RETURNS void AS $$
BEGIN
    EXECUTE 'DROP SCHEMA IF EXISTS ' || quote_ident(tenant_schema) || ' CASCADE';
END;
$$ LANGUAGE plpgsql;

-- Trigger function to create tenant schema when new tenant is added
CREATE OR REPLACE FUNCTION create_tenant_schema_trigger()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM create_tenant_schema(NEW.schema);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS create_tenant_schema_trigger ON public.tenants;
CREATE TRIGGER create_tenant_schema_trigger
    AFTER INSERT ON public.tenants
    FOR EACH ROW
    EXECUTE FUNCTION create_tenant_schema_trigger(); 