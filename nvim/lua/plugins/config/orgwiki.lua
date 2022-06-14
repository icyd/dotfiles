local vimwiki_dir = os.getenv('VIMWIKI_HOME')

require('orgWiki').setup({
    wiki_path = { vimwiki_dir .. "/orgwiki/" },
    diary_path = vimwiki_dir .. "/orgwiki/diary",
})
