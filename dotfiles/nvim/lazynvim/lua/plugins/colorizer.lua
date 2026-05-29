return {
  "NvChad/nvim-colorizer.lua",
  event = "VeryLazy",
  opts = {
    filetypes = { "*" }, -- hoạt động trên mọi loại file
    user_default_options = {
      RGB = true, -- #RGB
      RRGGBB = true, -- #RRGGBB
      names = true, -- bỏ tên màu như "red"
      RRGGBBAA = true, -- hỗ trợ Color(0xAARRGGBB)
      AARRGGBB = true,
      css = true,
      mode = "virtualtext", -- background hoặc "virtualtext" để tô bên cạnh
    },
  },
}
