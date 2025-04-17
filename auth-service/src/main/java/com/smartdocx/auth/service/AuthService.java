package com.smartdocx.auth.service;

import com.smartdocx.auth.dto.LoginRequest;
import com.smartdocx.auth.dto.LoginResponse;
import com.smartdocx.auth.dto.RegisterRequest;

public interface AuthService {
    void register(RegisterRequest request);

    LoginResponse login(LoginRequest request);
}