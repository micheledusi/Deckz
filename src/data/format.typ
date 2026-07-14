// format.typ

// Dictionary of formats' parameters
// this is used to make code more modular and reusable
#let format-parameters = (
  default: (
    width: auto, // Placeholder. This should be specified in final usage
    height: auto, // Placeholder. This should be specified in final usage
    inset: 2pt + 3%, 
    outset: 0pt,
    radius: 2pt + 5%,
    // stroke: border-style, // TODO move from here
    // fill: bg-color, // TODO move
  ),
  inline: (
    width: 1.7em, 
    height: 0.8em,
    inset: 0pt, 
    outset: 0.13em,
    radius: 0.5em,
    stroke: none,
  ),
  mini: (
    width: 1.5em, 
    height: 2.1em,
  ),
  small: (
    width: 2.5em, 
    height: 3.5em,
  ),
  medium: (
    width: 6.5em, 
    height: 9.1em,
  ),
  large: (
    width: 10em, 
    height: 14em,
  ),
  square: (
    width: 10em, 
    height: 10em,
  ),
)

#{
  // When the module is imported, this should be executed
  for (format, params) in format-parameters.pairs() {
    if format != "default" {
      // For every parameter
      for key in format-parameters.default.keys() {
        if key not in params {
          format-parameters.at(format).insert(key, format-parameters.default.at(key))
        }
      }
    }
  }
  // This guarantees that every format has all the parameters to be displayed.
  // TODO for future releases: load configs from file.
}