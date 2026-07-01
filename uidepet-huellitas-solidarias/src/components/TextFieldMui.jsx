import { useState } from "react";

import TextField from "@mui/material/TextField";
import InputAdornment from "@mui/material/InputAdornment";
import IconButton from "@mui/material/IconButton";

import Visibility from "@mui/icons-material/Visibility";
import VisibilityOff from "@mui/icons-material/VisibilityOff";

function TextFieldMui({
  id,
  label,
  placeholder,
  type = "text",
  value,
  handleOnChange
}) {
  const [showPassword, setShowPassword] = useState(false);

  return (
    <TextField
      id={id}
      name={id}
      label={label}
      placeholder={placeholder}
      type={type === "password" && showPassword ? "text" : type}
      value={value}
      onChange={(e) => handleOnChange(e.target.value)}
      fullWidth
      size="small"
      variant="outlined"
      slotProps={{
        input: {
          endAdornment:
            type === "password" ? (
              <InputAdornment position="end">
                <IconButton
                  onClick={() => setShowPassword(!showPassword)}
                  edge="end"
                >
                  {showPassword ? <VisibilityOff /> : <Visibility />}
                </IconButton>
              </InputAdornment>
            ) : null
        }
      }}
    />
  );
}

export default TextFieldMui;