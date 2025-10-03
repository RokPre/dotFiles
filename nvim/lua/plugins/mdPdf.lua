return {
  "arminveres/md-pdf.nvim",
  branch = "main",
  lazy = true,
  keys = {
    {
      "<leader>,",
      function() require("md-pdf").convert_md_to_pdf() end,
      desc = "Markdown → PDF (preview)",
    },
  },
  opts = {
    margins = "1.5cm",
    highlight = "tango",
    toc = true,
    preview_cmd = function() return "zathura" end,
    ignore_viewer_state = false, -- good for Zathura
    output_path = "./",          -- keep relative; "./out" also OK
    pdf_engine = "pdflatex",     -- switch to "xelatex" if you set fonts
    -- fonts = { main_font = "DejaVuSerif", sans_font = "DejaVuSans", mono_font = "IosevkaTerm Nerd Font Mono" },
    -- pandoc_user_args = { "--standalone" }, -- optional
  },
}
