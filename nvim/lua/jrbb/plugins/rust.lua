return {
  {
    "saecki/crates.nvim",
    dependencies = "hrsh7th/nvim-cmp",
    ft = { "rust", "toml" },
    tag = "stable",
    opts = function()
      local Remap = require("jrbb.keymap")
      local vmap = Remap.vmap
      local nmap = Remap.nmap

      local crates = require("crates")

      nmap("<leader>ct", crates.toggle, { silent = true, desc = "Toggle Crates" })
      nmap("<leader>cr", crates.reload, { silent = true, desc = "Reload Crates" })
      nmap("<leader>cv", crates.show_versions_popup, { silent = true, desc = "Show Versions Popup" })
      nmap("<leader>cf", crates.show_features_popup, { silent = true, desc = "Show Features Popup" })
      nmap("<leader>cd", crates.show_dependencies_popup, { silent = true, desc = "Show Dependencies Popup" })
      nmap("<leader>cu", crates.update_crate, { silent = true, desc = "Update Crate" })
      vmap("<leader>cu", crates.update_crates, { silent = true, desc = "Update Crates" })
      nmap("<leader>ca", crates.update_all_crates, { silent = true, desc = "Update All Crates" })
      nmap("<leader>cU", crates.upgrade_crate, { silent = true, desc = "Upgrade Crate" })
      vmap("<leader>cU", crates.upgrade_crates, { silent = true, desc = "Upgrade Crates" })
      nmap("<leader>cA", crates.upgrade_all_crates, { silent = true, desc = "Upgrade All Crates" })
      nmap("<leader>ce", crates.expand_plain_crate_to_inline_table, { silent = true, desc = "Expand Plain Crate" })
      nmap("<leader>cE", crates.extract_crate_into_table, { silent = true, desc = "Extract Crate" })
      nmap("<leader>cH", crates.open_homepage, { silent = true, desc = "Open Homepage" })
      nmap("<leader>cR", crates.open_repository, { silent = true, desc = "Open Repository" })
      nmap("<leader>cD", crates.open_documentation, { silent = true, desc = "Open Documentation" })
      nmap("<leader>cC", crates.open_crates_io, { silent = true, desc = "Open Crates.io" })

      return {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        text = {
          loading = " ⏳ Loading",
          version = " 🟢 %s",
          prerelease = " prerelease %s",
          yanked = " error %s",
          nomatch = " No match",
          upgrade = " 🟡 %s",
          error = " Error fetching crate",
        },
        popup = {
          text = {
            title = " %s",
            pill_left = ">",
            pill_right = "<",
            description = "%s",
            created_label = "created        ",
            created = "%s",
            updated_label = "updated        ",
            updated = "%s",
            downloads_label = "downloads      ",
            downloads = "%s",
            homepage_label = "homepage       ",
            homepage = "%s",
            repository_label = "repository     ",
            repository = "%s",
            documentation_label = " documentation  ",
            documentation = "%s",
            crates_io_label = " crates.io      ",
            crates_io = "%s",
            categories_label = "categories     ",
            keywords_label = "keywords       ",
            version = "  %s",
            prerelease = "%s",
            yanked = "%s",
            version_date = "  %s",
            feature = "  %s",
            enabled = "%s",
            transitive = "%s",
            normal_dependencies_title = "Dependencies",
            build_dependencies_title = "Build dependencies",
            dev_dependencies_title = "Dev dependencies",
            dependency = "  %s",
            optional = "%s",
            dependency_version = "  %s",
            loading = " ⏳ Loading",
          },
          keys = {
            hide = { "q" },
            open_url = { "<cr>" },
            select = { "<cr>" },
            select_alt = { "s" },
            toggle_feature = { "<cr>" },
            copy_value = { "yy" },
            goto_item = { "gd" },
            jump_forward = { "<c-i>" },
            jump_back = { "<c-o>" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("crates").setup(opts)
    end,
  },
}
