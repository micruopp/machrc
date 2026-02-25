view_node_compatibility() {
  # https://stackoverflow.com/a/70950326,
  # https://stackoverflow.com/questions/42805913
  # This isn't a perfect solution, but it's _pretty good_.
  # It doesn't match some things, like
  # ```
  # "node": {
  #   ...
  # }
  # ```
  grep -hoP '"node":.*' node_modules/*/package.json | sort
}
