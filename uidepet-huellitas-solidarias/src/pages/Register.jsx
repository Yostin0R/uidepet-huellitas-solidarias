import { useState } from "react";
import { useNavigate } from "react-router-dom";

import {
  Box,
  Button,
  Checkbox,
  FormControlLabel,
  TextField,
  Typography,
} from "@mui/material";

import ArrowForwardIcon from "@mui/icons-material/ArrowForward";

import hennryImage from "../assets/hennry.jpg";

function RegisterPage() {
  const navigate = useNavigate();

  const [nombres, setNombres] = useState("");
  const [apellidos, setApellidos] = useState("");
  const [cedula, setCedula] = useState("");
  const [telefono, setTelefono] = useState("");
  const [correo, setCorreo] = useState("");
  const [direccion, setDireccion] = useState("");
  const [password, setPassword] = useState("");
  const [confirmarPassword, setConfirmarPassword] = useState("");
  const [aceptaTerminos, setAceptaTerminos] = useState(false);

  const soloLetras = /^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]+$/;
  const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  const nombresValidos = nombres.trim().length >= 3 && soloLetras.test(nombres);
  const apellidosValidos =
    apellidos.trim().length >= 3 && soloLetras.test(apellidos);
  const cedulaValida = cedula.length === 10;
  const telefonoValido = telefono.length === 10;
  const correoEsValido = correoValido.test(correo);
  const direccionValida = direccion.trim().length >= 5;
  const passwordValida = password.length >= 8;
  const confirmarValida =
    confirmarPassword.length >= 8 && confirmarPassword === password;

  const formularioValido =
    nombresValidos &&
    apellidosValidos &&
    cedulaValida &&
    telefonoValido &&
    correoEsValido &&
    direccionValida &&
    passwordValida &&
    confirmarValida &&
    aceptaTerminos;

  const handleChangeLetras = (value, setter) => {
    const textoLimpio = value.replace(/[^A-Za-zÁÉÍÓÚáéíóúÑñ\s]/g, "");
    setter(textoLimpio);
  };

  const handleChangeNumeros = (value, setter, maxLength) => {
    const numerosLimpios = value.replace(/\D/g, "").slice(0, maxLength);
    setter(numerosLimpios);
  };

  const handleRegister = () => {
    if (!formularioValido) {
      alert("Complete correctamente todos los campos.");
      return;
    }

    alert("Cuenta creada correctamente.");
    navigate("/ingreso");
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        backgroundColor: "#f7f4f6",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        px: { xs: 2, md: 4 },
        py: { xs: 3, md: 4 },
        overflowX: "hidden",
      }}
    >
      <Box
        sx={{
          width: "100%",
          maxWidth: "1180px",
          height: { xs: "auto", md: "820px" },
          display: "grid",
          gridTemplateColumns: { xs: "1fr", md: "0.85fr 1.15fr" },
          backgroundColor: "#ffffff",
          borderRadius: "20px",
          overflow: "hidden",
          boxShadow: "0 18px 50px rgba(80, 0, 45, 0.10)",
        }}
      >
        {/* Imagen izquierda fija */}
        <Box
          sx={{
            position: "relative",
            display: { xs: "none", md: "block" },
            height: "820px",
            backgroundImage: `linear-gradient(180deg, rgba(0,0,0,0.02), rgba(0,0,0,0.45)), url(${hennryImage})`,
            backgroundSize: "cover",
            backgroundPosition: "center",
          }}
        >
          <Box
            sx={{
              position: "absolute",
              left: 34,
              bottom: 34,
              color: "#ffffff",
            }}
          >
            <Typography sx={{ fontSize: "24px", fontWeight: 900 }}>
              UidePet
            </Typography>
            <Typography sx={{ fontSize: "16px", mt: 1 }}>
              Huellitas Solidarias
            </Typography>
          </Box>
        </Box>

        {/* Formulario */}
        <Box
          sx={{
            height: { xs: "auto", md: "820px" },
            overflowY: { xs: "visible", md: "auto" },
            px: { xs: 3, sm: 5, md: 7 },
            py: { xs: 4, md: 5 },
          }}
        >
          <Typography
            sx={{
              color: "#8A004B",
              fontSize: { xs: "30px", md: "38px" },
              fontWeight: 900,
              mb: 1.5,
            }}
          >
            Crear una cuenta
          </Typography>

          <Typography
            sx={{
              color: "#5f4b55",
              fontSize: "15px",
              lineHeight: 1.6,
              mb: 3,
              maxWidth: "600px",
            }}
          >
            Únete a nuestra plataforma académica para la adopción responsable.
            Cada registro es un paso hacia un hogar lleno de amor.
          </Typography>

          <Box
            sx={{
              display: "grid",
              gridTemplateColumns: { xs: "1fr", sm: "1fr 1fr" },
              gap: 2.2,
            }}
          >
            <Box>
              <Typography sx={labelStyle}>Nombres</Typography>
              <TextField
                fullWidth
                placeholder="Ej: Juan Pablo"
                value={nombres}
                onChange={(e) => handleChangeLetras(e.target.value, setNombres)}
                error={nombres.length > 0 && !nombresValidos}
                helperText={
                  nombres.length > 0 && !nombresValidos
                    ? "Solo letras, mínimo 3 caracteres."
                    : " "
                }
                sx={inputStyle}
              />
            </Box>

            <Box>
              <Typography sx={labelStyle}>Apellidos</Typography>
              <TextField
                fullWidth
                placeholder="Ej: Pérez González"
                value={apellidos}
                onChange={(e) =>
                  handleChangeLetras(e.target.value, setApellidos)
                }
                error={apellidos.length > 0 && !apellidosValidos}
                helperText={
                  apellidos.length > 0 && !apellidosValidos
                    ? "Solo letras, mínimo 3 caracteres."
                    : " "
                }
                sx={inputStyle}
              />
            </Box>

            <Box>
              <Typography sx={labelStyle}>Cédula</Typography>
              <TextField
                fullWidth
                placeholder="10 dígitos"
                value={cedula}
                onChange={(e) =>
                  handleChangeNumeros(e.target.value, setCedula, 10)
                }
                error={cedula.length > 0 && !cedulaValida}
                helperText={
                  cedula.length > 0 && !cedulaValida
                    ? "La cédula debe tener 10 números."
                    : " "
                }
                sx={inputStyle}
              />
            </Box>

            <Box>
              <Typography sx={labelStyle}>Teléfono</Typography>
              <TextField
                fullWidth
                placeholder="Ej: 0991234567"
                value={telefono}
                onChange={(e) =>
                  handleChangeNumeros(e.target.value, setTelefono, 10)
                }
                error={telefono.length > 0 && !telefonoValido}
                helperText={
                  telefono.length > 0 && !telefonoValido
                    ? "El teléfono debe tener 10 números."
                    : " "
                }
                sx={inputStyle}
              />
            </Box>
          </Box>

          <Typography sx={labelStyle}>Correo Electrónico</Typography>
          <TextField
            fullWidth
            placeholder="usuario@correo.com"
            value={correo}
            onChange={(e) => setCorreo(e.target.value)}
            error={correo.length > 0 && !correoEsValido}
            helperText={
              correo.length > 0 && !correoEsValido
                ? "Ingrese un correo válido."
                : " "
            }
            sx={inputStyle}
          />

          <Typography sx={labelStyle}>Dirección Completa</Typography>
          <TextField
            fullWidth
            placeholder="Calle principal y transversal, Sector"
            value={direccion}
            onChange={(e) => setDireccion(e.target.value)}
            error={direccion.length > 0 && !direccionValida}
            helperText={
              direccion.length > 0 && !direccionValida
                ? "Ingrese una dirección válida."
                : " "
            }
            sx={inputStyle}
          />

          <Box
            sx={{
              display: "grid",
              gridTemplateColumns: { xs: "1fr", sm: "1fr 1fr" },
              gap: 2.2,
            }}
          >
            <Box>
              <Typography sx={labelStyle}>Contraseña</Typography>
              <TextField
                fullWidth
                type="password"
                placeholder="Mínimo 8 caracteres"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                error={password.length > 0 && !passwordValida}
                helperText={
                  password.length > 0 && !passwordValida
                    ? "Mínimo 8 caracteres."
                    : " "
                }
                sx={inputStyle}
              />
            </Box>

            <Box>
              <Typography sx={labelStyle}>Confirmar Contraseña</Typography>
              <TextField
                fullWidth
                type="password"
                placeholder="Repite la contraseña"
                value={confirmarPassword}
                onChange={(e) => setConfirmarPassword(e.target.value)}
                error={confirmarPassword.length > 0 && !confirmarValida}
                helperText={
                  confirmarPassword.length > 0 && !confirmarValida
                    ? "Las contraseñas no coinciden."
                    : " "
                }
                sx={inputStyle}
              />
            </Box>
          </Box>

          <FormControlLabel
            sx={{
              mt: 0.5,
              alignItems: "flex-start",
              color: "#5f4b55",
            }}
            control={
              <Checkbox
                checked={aceptaTerminos}
                onChange={(e) => setAceptaTerminos(e.target.checked)}
                sx={{
                  color: "#d9b4c4",
                  "&.Mui-checked": {
                    color: "#8A004B",
                  },
                }}
              />
            }
            label={
              <Typography sx={{ fontSize: "14.5px", lineHeight: 1.5 }}>
                Acepto los{" "}
                <Box
                  component="span"
                  sx={{ color: "#8A004B", fontWeight: 700 }}
                >
                  términos y condiciones
                </Box>{" "}
                de adopción responsable y confirmo que la información es veraz.
              </Typography>
            }
          />

          <Button
            fullWidth
            variant="contained"
            endIcon={<ArrowForwardIcon />}
            onClick={handleRegister}
            disabled={!formularioValido}
            sx={{
              height: "52px",
              borderRadius: "8px",
              backgroundColor: "#8A004B",
              color: "#ffffff",
              fontWeight: 800,
              textTransform: "none",
              mt: 2,
              mb: 2,
              boxShadow: "0px 8px 18px rgba(138, 0, 75, 0.25)",
              "&:hover": {
                backgroundColor: "#73003F",
              },
              "&.Mui-disabled": {
                backgroundColor: "#d9d9d9",
                color: "#999999",
                boxShadow: "none",
              },
            }}
          >
            Crear cuenta
          </Button>

          <Box sx={{ textAlign: "center" }}>
            <Typography sx={{ color: "#5f4b55", fontSize: "14.5px" }}>
              ¿Ya tienes una cuenta?{" "}
              <Box
                component="span"
                onClick={() => navigate("/ingreso")}
                sx={{
                  color: "#8A004B",
                  fontWeight: 800,
                  cursor: "pointer",
                }}
              >
                Inicia sesión
              </Box>
            </Typography>

            <Typography
              sx={{
                color: "#5f4b55",
                fontSize: "14.5px",
                mt: 1,
              }}
            >
              ¿Representas una fundación o refugio?{" "}
              <Box
                component="span"
                sx={{
                  color: "#8A004B",
                  fontWeight: 800,
                  cursor: "pointer",
                }}
              >
                Solicita una cuenta de organización
              </Box>
            </Typography>
          </Box>
        </Box>
      </Box>
    </Box>
  );
}

const labelStyle = {
  fontSize: "14px",
  fontWeight: 700,
  color: "#242424",
  mb: 1,
};

const inputStyle = {
  mb: 0,

  "& .MuiOutlinedInput-root": {
    borderRadius: "8px",
    backgroundColor: "#fbfafb",

    "& fieldset": {
      borderColor: "#e4bdcd",
    },

    "&:hover fieldset": {
      borderColor: "#8A004B",
    },

    "&.Mui-focused fieldset": {
      borderColor: "#8A004B",
      borderWidth: "1.5px",
    },
  },

  "& .MuiInputBase-input": {
    height: "22px",
    padding: "14px 14px",
    fontSize: "15px",
  },

  "& .MuiFormHelperText-root": {
    minHeight: "20px",
    marginLeft: "4px",
    marginTop: "4px",
    fontSize: "12px",
  },
};

export default RegisterPage;