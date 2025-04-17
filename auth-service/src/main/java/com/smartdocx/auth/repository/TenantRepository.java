package com.smartdocx.auth.repository;

import com.smartdocx.auth.model.Tenant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TenantRepository extends JpaRepository<Tenant, Long> {
}