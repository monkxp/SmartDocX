package com.smartdocx.auth.tenant;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import java.io.IOException;

@Component
public class TenantInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String tenantId = request.getHeader("X-Tenant-ID");
        if (tenantId != null && !tenantId.isEmpty()) {
            if (tenantId.matches("^[a-z0-9_]+$")) {
                TenantContext.setCurrentTenant(tenantId);
                return true;
            } else {
                try {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Tenant ID");
                } catch (IOException e) {
                    // Log the error but don't rethrow since we're in an interceptor
                    return false;
                }
                return false;
            }
        }
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler,
            Exception ex) {
        TenantContext.clear();
    }
}