return {
  "stevearc/conform.nvim",
  config = function()
    local ok, mason = pcall(require, "mason")
    if ok then
      local cfg = require("mason.settings").current
      local ensure = cfg.ensure_installed or {}

      vim.list_extend(ensure, {
        "stylua",
        "autopep8",
        "autoflake",
        "reorder-python-imports",
        "xmlformatter",
        "shfmt"
      })

      cfg.ensure_installed = ensure

      local mr_ok, mr = pcall(require,"mason-registry")
      if mr_ok then
        vim.defer_fn(function()
          mr.refresh(function()
            for _, tool in ipairs(cfg.ensure_installed) do
              local p = mr.get_package(tool)
              if not p:is_installed() then
                p:install()
              end
            end
          end)
        end, 100)
      end
    end

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "autopep8", "autoflake", "reorder-python-imports" },
        xml = { "xmlformatter" },
        bash = {"shfmt"},
        ["_"] = { "trim_whitespace" },
      },
    })
  end,
}
