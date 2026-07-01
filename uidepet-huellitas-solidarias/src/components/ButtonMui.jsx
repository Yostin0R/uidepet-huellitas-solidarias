import Button from "@mui/material/Button";

function ButtonMui({ text, handleClick, disabled = false }) {
  return (
    <Button
      variant="contained"
      color="success"
      fullWidth
      disabled={disabled}
      onClick={handleClick}
    >
      {text}
    </Button>
  );
}

export default ButtonMui;