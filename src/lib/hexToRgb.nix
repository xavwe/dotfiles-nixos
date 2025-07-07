{ lib }:

let
  parseHex = hex:
    let
      # Remove '#' if present
      cleanHex = if builtins.substring 0 1 hex == "#" then builtins.substring 1 (builtins.stringLength hex - 1) hex else hex;
      # Split into R, G, B components
      r = builtins.substring 0 2 cleanHex;
      g = builtins.substring 2 2 cleanHex;
      b = builtins.substring 4 2 cleanHex;
    in {
      inherit r g b;
    };

  hexToDecimal = hex:
    let
      hexCharToDecimal = char:
        if char == "0" then 0
        else if char == "1" then 1
        else if char == "2" then 2
        else if char == "3" then 3
        else if char == "4" then 4
        else if char == "5" then 5
        else if char == "6" then 6
        else if char == "7" then 7
        else if char == "8" then 8
        else if char == "9" then 9
        else if char == "a" || char == "A" then 10
        else if char == "b" || char == "B" then 11
        else if char == "c" || char == "C" then 12
        else if char == "d" || char == "D" then 13
        else if char == "e" || char == "E" then 14
        else if char == "f" || char == "F" then 15
        else 0; # Should not happen with valid hex input

      # Assuming hex is always 2 characters for R, G, B components
      char1 = builtins.substring 0 1 hex;
      char2 = builtins.substring 1 1 hex;
    in (hexCharToDecimal char1 * 16) + hexCharToDecimal char2;

in {
  hexToRgb = hex:
    let
      components = parseHex hex;
    in "rgb(${toString (hexToDecimal components.r)}, ${toString (hexToDecimal components.g)}, ${toString (hexToDecimal components.b)})";
}
