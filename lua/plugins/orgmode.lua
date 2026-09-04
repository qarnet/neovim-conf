-- Org mode for the serial-mcp product backlog.
-- Agenda files cover ACTIVE backlog items only; completed/ and dropped/
-- stay out of the default agenda (they are retained history). The template
-- sits outside active/ so it never appears either.
return {
  {
    "nvim-orgmode/orgmode",
    -- The plugin installs its own treesitter grammar (pinned 2.0.4) during
    -- setup; nvim-treesitter main branch no longer bundles org, so do NOT
    -- add "org" to ensure_installed there.
    opts = {
      org_agenda_files = {
        "~/repos/serial-mcp/docs/product/backlog/active/**/*",
      },
      org_default_notes_file = "~/repos/serial-mcp/docs/product/backlog/active/.refile.org",
      -- serial-mcp product workflow (docs/product/README.md is the contract).
      org_todo_keywords = {
        "BACKLOG",
        "READY",
        "IN_PROGRESS",
        "BLOCKED",
        "REVIEW",
        "|",
        "DONE",
        "DROPPED",
      },
      org_todo_keyword_faces = {
        ["REVIEW"] = ":foreground #e0af68 :slant italic",
        ["BLOCKED"] = ":foreground #f7768e :weight bold",
        ["IN_PROGRESS"] = ":foreground #7aa2f7 :weight bold",
      },
      -- Numeric priorities: [#0] = P0 urgent, [#1] near-term,
      -- [#2] default, [#3] speculative.
      org_priority_highest = 0,
      org_priority_default = 2,
      org_priority_lowest = 3,
      org_agenda_span = "month",
      org_agenda_start_on_weekday = false,
      org_agenda_custom_commands = {
        -- Product overview: everything active, most urgent state first.
        -- TODO-keyword matcher syntax is "/KEYWORDS" (docs/configuration.org).
        -- NOTE: nvim-orgmode 0.7.3 parses keyword values with Lua "%w+",
        -- which does not include underscore, so "/IN_PROGRESS" cannot be
        -- written positively. Use negation instead: /!-DONE-DROPPED equals
        -- exactly the five active states. "/!-DONE-DROPPED" parses
        -- "-DONE-DROPPED" as one AND-group excluding both terminal states.
        o = {
          description = "Product overview (all active)",
          types = {
            {
              type = "tags_todo",
              match = "/!-DONE-DROPPED",
              org_agenda_overriding_header = "Active product backlog",
              org_agenda_sorting_strategy = { "todo-state-up", "priority-down" },
            },
          },
        },
        -- Ready queue: what can be picked up next.
        r = {
          description = "Ready queue",
          types = {
            {
              type = "tags_todo",
              match = "/READY",
              org_agenda_overriding_header = "Ready to implement",
              org_agenda_sorting_strategy = { "priority-down" },
            },
          },
        },
        -- Needs attention: human action required.
        n = {
          description = "Needs attention (REVIEW + BLOCKED)",
          types = {
            {
              type = "tags_todo",
              match = "/REVIEW",
              org_agenda_overriding_header = "Awaiting human review",
              org_agenda_sorting_strategy = { "priority-down" },
            },
            {
              type = "tags_todo",
              match = "/BLOCKED",
              org_agenda_overriding_header = "Blocked",
              org_agenda_sorting_strategy = { "priority-down" },
            },
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "org (serial-mcp backlog)" },
      },
    },
  },
}