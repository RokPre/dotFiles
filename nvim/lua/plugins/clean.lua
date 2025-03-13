return {
  "drybalka/clean.nvim",
  config = function()
    require("clean").clean_keymap()
    require("clean").clean_plugins()
  end
}
