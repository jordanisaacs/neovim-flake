{lib}: {
  inputsToRaw = inputs: availablePlugins: lib.genAttrs availablePlugins (n: {src = inputs.${n};});
}
