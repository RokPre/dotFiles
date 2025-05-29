return {
  "rcarriga/nvim-dap-ui",
  -- virtual text for the debugger
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
  keys = {
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
  },
}
