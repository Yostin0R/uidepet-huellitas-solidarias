import Typography from "@mui/material/Typography";

function TextMui({ value, variant = "body1", color = "text.primary" }) {
  return (
    <Typography variant={variant} color={color}>
      {value}
    </Typography>
  );
}

export default TextMui;