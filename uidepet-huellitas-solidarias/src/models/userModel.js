export const userModel = {
  login(correo, password) {
    const users = [
      {
        correo: "usuario@huellitas.com",
        password: "123456",
        rol: "usuario",
        nombre: "Valentina Silva",
      },
      {
        correo: "fundacion@huellitas.com",
        password: "123456",
        rol: "fundacion",
        nombre: "Fundación Huellitas",
      },
    ];

    return users.find(
      (user) => user.correo === correo && user.password === password
    );
  },
};