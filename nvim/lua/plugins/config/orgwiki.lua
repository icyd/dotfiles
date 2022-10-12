local vimwiki_dir = os.getenv('VIMWIKI_HOME')
if vimwiki_dir == nil or vimwiki_dir == "" then
    vimwiki_dir = os.getenv('HOME') .. '/.org'
end

require('orgWiki').setup({
    wiki_path = { vimwiki_dir .. "/orgwiki/" },
    diary_path = vimwiki_dir .. "/orgwiki/diary",
})
