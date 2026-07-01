import { useState } from "react";
import { useNavigate } from "react-router-dom";

import {
  Alert,
  Box,
  Button,
  FormControl,
  InputLabel,
  MenuItem,
  Select,
  Step,
  StepLabel,
  Stepper,
  TextField,
  Typography,
} from "@mui/material";

import ArrowForwardIcon from "@mui/icons-material/ArrowForward";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import UploadFileIcon from "@mui/icons-material/UploadFile";

import fundacionBg from "../assets/fundacion-bg.jpg";

function RegistroFundacionPage() {
  const navigate = useNavigate();

  const [activeStep, setActiveStep] = useState(0);

  const [nombreFundacion, setNombreFundacion] = useState("");
  const [ruc, setRuc] = useState("");
  const [representante, setRepresentante] = useState("");
  const [correo, setCorreo] = useState("");
  const [telefono, setTelefono] = useState("");
  const [ciudad, setCiudad] = useState("");

  const [descripcion, setDescripcion] = useState("");
  const [documento, setDocumento] = useState(null);

  const soloLetras = /^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]+$/;
  const correoValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  const nombreValido = nombreFundacion.trim().length >= 3;
  const rucValido = ruc.length === 13;
  const representanteValido =
    representante.trim().length >= 3 && soloLetras.test(representante);
  const correoEsValido = correoValido.test(correo);
  const telefonoValido = telefono.length === 10;
  const ciudadValida = ciudad !== "";

  const descripcionValida = descripcion.trim().length >= 20;
  const documentoValido = documento !== null;

  const pasoUnoValido =
    nombreValido &&
    rucValido &&
    representanteValido &&
    correoEsValido &&
    telefonoValido &&
    ciudadValida;

  const pasoDosValido = descripcionValida && documentoValido;

  const handleChangeNumeros = (value, setter, maxLength) => {
    const limpio = value.replace(/\D/g, "").slice(0, maxLength);
    setter(limpio);
  };

  const handleChangeLetras = (value, setter) => {
    const limpio = value.replace(/[^A-Za-zÁÉÍÓÚáéíóúÑñ\s]/g, "");
    setter(limpio);
  };

  const handleDocumento = (event) => {
    const file = event.target.files[0];

    if (!file) return;

    const esPdf = file.type === "application/pdf";
    const pesoValido = file.size <= 5 * 1024 * 1024;

    if (!esPdf) {
      alert("El documento debe ser PDF.");
      return;
    }

    if (!pesoValido) {
      alert("El PDF no debe superar los 5MB.");
      return;
    }

    setDocumento(file);
  };

  const handleNext = () => {
    if (!pasoUnoValido) {
      alert("Complete correctamente los datos de la organización.");
      return;
    }

    setActiveStep(1);
  };

  const handleSubmit = () => {
    if (!pasoDosValido) {
      alert("Complete la descripción y adjunte el documento PDF.");
      return;
    }

    alert("Solicitud de organización enviada correctamente.");
    navigate("/ingreso");
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        backgroundColor: "#f7f4f6",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        px: { xs: 2, md: 4 },
        py: { xs: 3, md: 5 },
      }}
    >
      <Box
        sx={{
          width: "100%",
          maxWidth: "1120px",
          display: "grid",
          gridTemplateColumns: { xs: "1fr", md: "0.85fr 1.15fr" },
          backgroundColor: "#ffffff",
          borderRadius: "22px",
          overflow: "hidden",
          boxShadow: "0 18px 50px rgba(80, 0, 45, 0.10)",
        }}
      >
        <Box
          sx={{
            display: { xs: "none", md: "flex" },
            flexDirection: "column",
            justifyContent: "space-between",
            minHeight: "700px",
            p: 5,
            backgroundImage: `linear-gradient(160deg, rgba(70,0,40,0.82), rgba(151,0,79,0.55)), url(${fundacionBg})`,
            backgroundSize: "cover",
            backgroundPosition: "center",
            color: "#ffffff",
          }}
        >
          <Box>
            <Typography sx={{ fontSize: "22px", fontWeight: 900 }}>
              Huellitas Solidarias
            </Typography>
            <Typography sx={{ fontSize: "14px", mt: 0.5 }}>
              Proyecto de Vinculación
            </Typography>
          </Box>

          <Box>
            <Typography
              sx={{
                fontSize: "38px",
                fontWeight: 900,
                lineHeight: 1.15,
                mb: 2,
              }}
            >
              Integridad y Compromiso Social
            </Typography>

            <Typography sx={{ fontSize: "16px", lineHeight: 1.7 }}>
              Únase a nuestra red académica de refugios. Su organización pasará
              por un proceso de validación para garantizar el bienestar animal y
              la transparencia institucional.
            </Typography>
          </Box>

          <Typography sx={{ fontWeight: 800 }}>UIDE</Typography>
        </Box>

        <Box
          sx={{
            px: { xs: 3, sm: 5, md: 7 },
            py: { xs: 4, md: 5 },
          }}
        >
          <Typography
            sx={{
              color: "#1f1f1f",
              fontSize: { xs: "30px", md: "38px" },
              fontWeight: 900,
              mb: 1.5,
            }}
          >
            Registrar fundación o refugio
          </Typography>

          <Typography
            sx={{
              color: "#5f4b55",
              fontSize: "15px",
              lineHeight: 1.6,
              mb: 3,
            }}
          >
            Complete la información oficial de su organización. Los campos con
            asterisco (*) son obligatorios.
          </Typography>

          <Stepper
            activeStep={activeStep}
            sx={{
              mb: 4,
              "& .MuiStepIcon-root.Mui-active": {
                color: "#97004F",
              },
              "& .MuiStepIcon-root.Mui-completed": {
                color: "#97004F",
              },
            }}
          >
            <Step>
              <StepLabel>Datos</StepLabel>
            </Step>
            <Step>
              <StepLabel>Respaldo</StepLabel>
            </Step>
          </Stepper>

          {activeStep === 0 && (
            <>
              <Typography sx={labelStyle}>
                Nombre de la Fundación / Refugio *
              </Typography>
              <TextField
                fullWidth
                placeholder="Ej. Fundación Rescate Animal"
                value={nombreFundacion}
                onChange={(e) => setNombreFundacion(e.target.value)}
                error={nombreFundacion.length > 0 && !nombreValido}
                helperText={
                  nombreFundacion.length > 0 && !nombreValido
                    ? "Ingrese mínimo 3 caracteres."
                    : " "
                }
                sx={inputStyle}
              />

              <Box sx={twoColumns}>
                <Box>
                  <Typography sx={labelStyle}>RUC *</Typography>
                  <TextField
                    fullWidth
                    placeholder="13 dígitos"
                    value={ruc}
                    onChange={(e) =>
                      handleChangeNumeros(e.target.value, setRuc, 13)
                    }
                    error={ruc.length > 0 && !rucValido}
                    helperText={
                      ruc.length > 0 && !rucValido
                        ? "El RUC debe tener 13 números."
                        : " "
                    }
                    sx={inputStyle}
                  />
                </Box>

                <Box>
                  <Typography sx={labelStyle}>
                    Representante Legal / Responsable *
                  </Typography>
                  <TextField
                    fullWidth
                    placeholder="Nombre completo"
                    value={representante}
                    onChange={(e) =>
                      handleChangeLetras(e.target.value, setRepresentante)
                    }
                    error={representante.length > 0 && !representanteValido}
                    helperText={
                      representante.length > 0 && !representanteValido
                        ? "Solo letras, mínimo 3 caracteres."
                        : " "
                    }
                    sx={inputStyle}
                  />
                </Box>
              </Box>

              <Box sx={twoColumns}>
                <Box>
                  <Typography sx={labelStyle}>
                    Correo Electrónico Institucional *
                  </Typography>
                  <TextField
                    fullWidth
                    placeholder="contacto@fundacion.org"
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
                </Box>

                <Box>
                  <Typography sx={labelStyle}>
                    Teléfono de Contacto *
                  </Typography>
                  <TextField
                    fullWidth
                    placeholder="0999999999"
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

              <Typography sx={labelStyle}>Ciudad de Operación *</Typography>
              <FormControl fullWidth sx={{ mb: 3 }}>
                <InputLabel>Seleccione una ciudad</InputLabel>
                <Select
                  value={ciudad}
                  label="Seleccione una ciudad"
                  onChange={(e) => setCiudad(e.target.value)}
                  sx={{
                    borderRadius: "8px",
                    backgroundColor: "#fbfafb",
                    "& fieldset": {
                      borderColor: "#e4bdcd",
                    },
                  }}
                >
                  <MenuItem value="Loja">Loja</MenuItem>
                  <MenuItem value="Quito">Quito</MenuItem>
                  <MenuItem value="Cuenca">Cuenca</MenuItem>
                  <MenuItem value="Guayaquil">Guayaquil</MenuItem>
                </Select>
              </FormControl>

              <Button
                fullWidth
                variant="contained"
                endIcon={<ArrowForwardIcon />}
                onClick={handleNext}
                disabled={!pasoUnoValido}
                sx={buttonStyle}
              >
                Continuar
              </Button>
            </>
          )}

          {activeStep === 1 && (
            <>
              <Typography sx={labelStyle}>
                Descripción de la Organización *
              </Typography>
              <Typography sx={{ fontSize: "13px", color: "#8b6b78", mb: 1 }}>
                Breve resumen de su misión, capacidad instalada y años de
                operación.
              </Typography>

              <TextField
                fullWidth
                multiline
                rows={5}
                placeholder="Nuestra fundación se dedica a..."
                value={descripcion}
                onChange={(e) => setDescripcion(e.target.value)}
                error={descripcion.length > 0 && !descripcionValida}
                helperText={
                  descripcion.length > 0 && !descripcionValida
                    ? "Ingrese mínimo 20 caracteres."
                    : " "
                }
                sx={inputStyle}
              />

              <Typography sx={labelStyle}>
                Documento de Respaldo Institucional *
              </Typography>
              <Typography sx={{ fontSize: "13px", color: "#8b6b78", mb: 1 }}>
                Adjunte un PDF como RUC, acuerdo ministerial, registro del MIES
                o estatutos. Máximo 5MB.
              </Typography>

              <Button
                component="label"
                fullWidth
                variant="outlined"
                startIcon={<UploadFileIcon />}
                sx={{
                  height: "88px",
                  borderStyle: "dashed",
                  borderColor: "#d8a9bd",
                  color: "#8A004B",
                  textTransform: "none",
                  fontWeight: 800,
                  mb: 2,
                  "&:hover": {
                    borderColor: "#8A004B",
                    backgroundColor: "#fff7fb",
                  },
                }}
              >
                {documento ? documento.name : "Subir archivo PDF"}
                <input
                  type="file"
                  accept="application/pdf"
                  hidden
                  onChange={handleDocumento}
                />
              </Button>

              <Alert
                severity="warning"
                sx={{
                  mb: 3,
                  border: "1px solid #ead0a8",
                  backgroundColor: "#fffaf0",
                }}
              >
                <strong>Revisión Administrativa:</strong> la solicitud será
                revisada por el equipo de vinculación. Recibirá una notificación
                en un plazo de 3 a 5 días laborables.
              </Alert>

              <Box sx={{ display: "flex", gap: 2 }}>
                <Button
                  fullWidth
                  variant="outlined"
                  startIcon={<ArrowBackIcon />}
                  onClick={() => setActiveStep(0)}
                  sx={{
                    height: "50px",
                    borderRadius: "8px",
                    borderColor: "#8A004B",
                    color: "#8A004B",
                    textTransform: "none",
                    fontWeight: 800,
                  }}
                >
                  Volver
                </Button>

                <Button
                  fullWidth
                  variant="contained"
                  endIcon={<ArrowForwardIcon />}
                  onClick={handleSubmit}
                  disabled={!pasoDosValido}
                  sx={buttonStyle}
                >
                  Enviar solicitud
                </Button>
              </Box>
            </>
          )}

          <Box sx={{ textAlign: "center", mt: 3 }}>
            <Typography sx={{ color: "#5f4b55", fontSize: "14px" }}>
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

const twoColumns = {
  display: "grid",
  gridTemplateColumns: { xs: "1fr", sm: "1fr 1fr" },
  gap: 2,
};

const inputStyle = {
  mb: 1.5,

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

  "& .MuiFormHelperText-root": {
    minHeight: "20px",
    marginLeft: "4px",
    marginTop: "4px",
    fontSize: "12px",
  },
};

const buttonStyle = {
  height: "50px",
  borderRadius: "8px",
  backgroundColor: "#8A004B",
  color: "#ffffff",
  fontWeight: 800,
  textTransform: "none",
  boxShadow: "0px 8px 18px rgba(138, 0, 75, 0.25)",

  "&:hover": {
    backgroundColor: "#73003F",
  },

  "&.Mui-disabled": {
    backgroundColor: "#d9d9d9",
    color: "#999999",
    boxShadow: "none",
  },
};

export default RegistroFundacionPage;