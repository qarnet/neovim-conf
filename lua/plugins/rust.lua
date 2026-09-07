return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            -- Check on save, but avoid compiling every optional Cargo feature.
            checkOnSave = true,
            cargo = {
              allFeatures = false,
            },
          },
        },
      },
    },
  },
}
