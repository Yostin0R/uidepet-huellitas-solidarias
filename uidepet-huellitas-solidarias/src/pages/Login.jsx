import { useState } from "react";
import { useNavigate } from "react-router-dom";

import {
  Box,
  Button,
  Divider,
  InputAdornment,
  TextField,
  Typography,
} from "@mui/material";

import EmailOutlinedIcon from "@mui/icons-material/EmailOutlined";
import LockOutlinedIcon from "@mui/icons-material/LockOutlined";
import ArrowForwardIcon from "@mui/icons-material/ArrowForward";

import { useLocalStorage } from "../storage/useLocalStorage";
import { userModel } from "../models/userModel";

import hennryImage from "../assets/hennry.jpg";
import logoUide from "../assets/logo-uide.png";

function LoginPage() {
  const navigate = useNavigate();

  const [correo, setCorreo] = useState("");
  const [password, setPassword] = useState("");

  const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const correoEsValido = correoValido.test(correo);
  const passwordEsValida = password.length >= 6;

  const mostrarErrorCorreo = correo.length > 0 && !correoEsValido;
  const mostrarErrorPassword = password.length > 0 && !passwordEsValida;

  const formularioValido = correoEsValido && passwordEsValida;

  const handleLogin = () => {
    if (!formularioValido) {
      alert("Ingrese un correo válido y una contraseña de mínimo 6 caracteres.");
      return;
    }

    const user = userModel.login(correo, password);

    if (user) {
      useLocalStorage.save("user", user);

      if (user.rol === "fundacion") {
        navigate("/dashboard-fundacion");
      } else {
        navigate("/perfil");
      }
    } else {
      alert("Credenciales incorrectas.");
    }
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        width: "100%",
        background:
          "linear-gradient(135deg, #f8f1f5 0%, #ffffff 45%, #f3e8ee 100%)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        px: { xs: 2, md: 5 },
        py: { xs: 3, md: 4 },
        overflow: "hidden",
      }}
    >
      <Box
        sx={{
          width: "100%",
          maxWidth: "1180px",
          height: { xs: "auto", md: "680px" },
          display: "grid",
          gridTemplateColumns: { xs: "1fr", md: "1.05fr 0.95fr" },
          backgroundColor: "#ffffff",
          borderRadius: "28px",
          overflow: "hidden",
          boxShadow: "0 24px 70px rgba(80, 0, 45, 0.14)",
          border: "1px solid rgba(151, 0, 79, 0.08)",
        }}
      >
        {/* Imagen izquierda */}
        <Box
          sx={{
            position: "relative",
            display: { xs: "none", md: "block" },
            height: "680px",
            backgroundImage: `linear-gradient(180deg, rgba(0,0,0,0.05), rgba(0,0,0,0.48)), url(${hennryImage})`,
            backgroundSize: "cover",
            backgroundPosition: "center",
          }}
        >
          <Box
            sx={{
              position: "absolute",
              left: 34,
              bottom: 34,
              right: 34,
              color: "#ffffff",
            }}
          >
            <Typography
              sx={{
                fontSize: "34px",
                fontWeight: 900,
                lineHeight: 1.1,
                textShadow: "0 3px 15px rgba(0,0,0,0.35)",
              }}
            >
              Huellitas Solidarias
            </Typography>

            <Typography
              sx={{
                mt: 1.5,
                fontSize: "16px",
                lineHeight: 1.6,
                maxWidth: "430px",
                color: "rgba(255,255,255,0.95)",
                textShadow: "0 2px 10px rgba(0,0,0,0.35)",
              }}
            >
              Plataforma de gestión, adopción responsable y apoyo al bienestar
              animal.
            </Typography>
          </Box>
        </Box>

        {/* Formulario */}
        <Box
          sx={{
            height: { xs: "auto", md: "680px" },
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            px: { xs: 3, sm: 6, md: 7 },
            py: { xs: 5, md: 5 },
            backgroundColor: "#ffffff",
            overflow: "hidden",
          }}
        >
          <Box
            sx={{
              width: "100%",
              maxWidth: "430px",
            }}
          >
            {/* Logo */}
            <Box
              sx={{
                display: "flex",
                alignItems: "center",
                mb: 4,
              }}
            >
              <Box
                component="img"
                src={logoUide}
                alt="Logo UIDE"
                sx={{
                  width: 48,
                  height: 48,
                  objectFit: "contain",
                  mr: 1.5,
                }}
              />

              <Box>
                <Typography
                  sx={{
                    color: "#97004F",
                    fontWeight: 900,
                    fontSize: "14px",
                    letterSpacing: "0.4px",
                    textTransform: "uppercase",
                    lineHeight: 1.15,
                  }}
                >
                  Universidad Internacional del Ecuador
                </Typography>

                <Typography
                  sx={{
                    color: "#6b4b5b",
                    fontSize: "13px",
                    mt: 0.4,
                  }}
                >
                  Huellitas Solidarias
                </Typography>
              </Box>
            </Box>

            <Typography
              sx={{
                fontWeight: 900,
                color: "#1f1f1f",
                fontSize: { xs: "30px", md: "34px" },
                mb: 1.2,
              }}
            >
              Iniciar sesión
            </Typography>

            <Typography
              sx={{
                color: "#5f4b55",
                fontSize: "15.5px",
                lineHeight: 1.65,
                mb: 3.2,
              }}
            >
              Accede al portal para gestionar adopciones, voluntariado y apoyo a
              fundaciones aliadas.
            </Typography>

            <Typography sx={labelStyle}>Correo electrónico</Typography>

            <TextField
              fullWidth
              placeholder="ejemplo@uide.edu.ec"
              value={correo}
              onChange={(event) => setCorreo(event.target.value)}
              error={mostrarErrorCorreo}
              helperText={mostrarErrorCorreo ? "Ingrese un correo válido." : " "}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <EmailOutlinedIcon sx={{ color: "#97004F" }} />
                  </InputAdornment>
                ),
              }}
              sx={inputStyle}
            />

            <Box
              sx={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                mb: 1,
                gap: 1,
              }}
            >
              <Typography sx={labelStyle}>Contraseña</Typography>

              <Typography
                sx={{
                  fontSize: "13px",
                  fontWeight: 800,
                  color: "#97004F",
                  cursor: "pointer",
                }}
              >
                ¿Olvidaste tu contraseña?
              </Typography>
            </Box>

            <TextField
              fullWidth
              type="password"
              placeholder="********"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              error={mostrarErrorPassword}
              helperText={
                mostrarErrorPassword
                  ? "La contraseña debe tener mínimo 6 caracteres."
                  : " "
              }
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <LockOutlinedIcon sx={{ color: "#97004F" }} />
                  </InputAdornment>
                ),
              }}
              sx={inputStyle}
            />

            <Button
              fullWidth
              variant="contained"
              endIcon={<ArrowForwardIcon />}
              onClick={handleLogin}
              disabled={!formularioValido}
              sx={{
                height: "52px",
                borderRadius: "14px",
                backgroundColor: "#97004F",
                color: "#ffffff",
                fontWeight: 900,
                textTransform: "none",
                fontSize: "15px",
                boxShadow: "0px 10px 22px rgba(151, 0, 79, 0.28)",
                mb: 3,
                "&:hover": {
                  backgroundColor: "#7d0041",
                },
                "&.Mui-disabled": {
                  backgroundColor: "#dedede",
                  color: "#999999",
                  boxShadow: "none",
                },
              }}
            >
              Ingresar
            </Button>

            <Divider sx={{ mb: 2.5 }} />

            <Box sx={{ textAlign: "center" }}>
              <Typography sx={{ color: "#5f4b55", fontSize: "14.5px" }}>
                ¿No tienes cuenta?{" "}
                <Box
                  component="span"
                  onClick={() => navigate("/registro")}
                  sx={{
                    color: "#97004F",
                    fontWeight: 900,
                    cursor: "pointer",
                  }}
                >
                  Regístrate
                </Box>
              </Typography>

              <Typography
                sx={{
                  color: "#5f4b55",
                  fontSize: "14.5px",
                  mt: 1,
                  lineHeight: 1.5,
                }}
              >
                ¿Representas una fundación o refugio?{" "}
                <Box
                  component="span"
                  onClick={() => navigate("/registro-fundacion")}
                  sx={{
                    color: "#97004F",
                    fontWeight: 900,
                    cursor: "pointer",
                  }}
                >
                  Solicita una cuenta
                </Box>
              </Typography>
            </Box>
          </Box>
        </Box>
      </Box>
    </Box>
  );
}

const labelStyle = {
  fontSize: "14px",
  fontWeight: 800,
  color: "#242424",
  mb: 1,
};

const inputStyle = {
  mb: 1.8,

  "& .MuiOutlinedInput-root": {
    borderRadius: "14px",
    height: "56px",
    backgroundColor: "#fcfafb",

    "& fieldset": {
      borderColor: "#ead0dc",
    },

    "&:hover fieldset": {
      borderColor: "#97004F",
    },

    "&.Mui-focused fieldset": {
      borderColor: "#97004F",
      borderWidth: "1.5px",
    },
  },

  "& .MuiInputBase-input": {
    overflow: "hidden",
    textOverflow: "ellipsis",
    whiteSpace: "nowrap",
  },

  "& .MuiFormHelperText-root": {
    minHeight: "20px",
    marginLeft: "4px",
    marginTop: "4px",
    fontSize: "12px",
  },
};

export default LoginPage;