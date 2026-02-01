-- required plugins for setting up connections to language server
return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"tailwindcss-language-server",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"bashls",
				"rust_analyzer",
				"lua_ls",
				"marksman",
				"pyright",
				"terraformls",
				"tflint",
				"jsonls",
				"gopls",
				"html",
				"cssls",
				"texlab",
				"ts_ls",
				"yamlls",
			},
			automatic_installation = false,
		},
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Configure LSP servers using vim.lsp.config
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
			}

			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
			}

			vim.lsp.config.bashls = {
				capabilities = capabilities,
			}

			vim.lsp.config.marksman = {
				capabilities = capabilities,
			}

			vim.lsp.config.pyright = {
				capabilities = capabilities,
			}

			vim.lsp.config.terraformls = {
				capabilities = capabilities,
			}

			vim.lsp.config.tflint = {
				capabilities = capabilities,
			}

			vim.lsp.config.html = {
				capabilities = capabilities,
			}

			vim.lsp.config.cssls = {
				capabilities = capabilities,
			}

			vim.lsp.config.texlab = {
				capabilities = capabilities,
			}

			vim.lsp.config.gopls = {
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				settings = {
					gopls = {
						completeUnimported = true,
					},
				},
			}

			vim.lsp.config.jsonls = {
				capabilities = capabilities,
			}

			vim.lsp.config.yamlls = {
				capabilities = capabilities,
				filetypes = { "yaml", "yml" },
				root_markers = { ".git" },
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = {
								"k8s/**/*.yaml",
								"k8s/**/*.yml",
								"kubernetes/**/*.yaml",
								"kubernetes/**/*.yml",
								"**/deployment*.yaml",
								"**/deployment*.yml",
								"**/service*.yaml",
								"**/service*.yml",
								"**/configmap*.yaml",
								"**/configmap*.yml",
							},
						},
						validate = true,
						completion = true,
						hover = true,
					},
				},
			}

			-- Enable all configured LSP servers
			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"bashls",
				"marksman",
				"pyright",
				"terraformls",
				"tflint",
				"html",
				"cssls",
				"texlab",
				"gopls",
				"jsonls",
				"yamlls",
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
		end,
	},
}
