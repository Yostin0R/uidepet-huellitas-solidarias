export const useLocalStorage = {
  save(key, value) {
    localStorage.setItem(key, JSON.stringify(value));
  },

  get(key) {
    return localStorage.getItem(key)
      ? JSON.parse(localStorage.getItem(key))
      : null;
  },

  delete(key) {
    localStorage.removeItem(key);
  },
};