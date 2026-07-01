import { Routes, Route, Navigate } from "react-router-dom";

import LoginPage from "../pages/Login";
import RegisterPage from "../pages/Register";
import RegistroFundacionPage from "../pages/RegistroFundacion";

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/ingreso" />} />
      <Route path="/ingreso" element={<LoginPage />} />
      <Route path="/registro" element={<RegisterPage />} />
      <Route path="/registro-fundacion" element={<RegistroFundacionPage />} />
      <Route path="/perfil" element={<h1>Perfil de usuario</h1>} />
      <Route path="/dashboard-fundacion" element={<h1>Dashboard Fundación</h1>} />
      <Route path="*" element={<h1>Página no encontrada</h1>} />
    </Routes>
  );
}

export default AppRoutes;