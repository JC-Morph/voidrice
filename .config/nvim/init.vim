" An vim, by Luko

map <space> <leader>

" ------------------------------------------------------------------------------
" Load plugins
" ------------------------------------------------------------------------------

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" >
				\ ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

map ,, :keepp /<++><CR>ca<
imap ,, <esc>:keepp /<++><CR>ca<

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" File navigation plugs
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
" Web dev plugs
" Plug 'leafgarland/typescript-vim'
" Plug 'jparise/vim-graphql'
Plug 'othree/html5.vim'
Plug 'ap/vim-css-color'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
call plug#end()

" ------------------------------------------------------------------------------
" Remaps
" ------------------------------------------------------------------------------

" Easier moving in split windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <leader>j <C-W>j<C-W>_
map <leader>k <C-W>k<C-W>_

" Enable dot commands over visual blocks
vnoremap . :normal .<CR>

" Hide search highlighting
nmap <silent> <leader>/ :noh<CR>

" Insert line in normal mode
nnoremap <leader>o o<esc>k
nnoremap <leader>O O<esc>j

" Move through wrapped lines row by row
nnoremap j gj
nnoremap k gk
" Move to last selection in visual mode
nnoremap gV `[v`]
" Move to next line match
nnoremap <leader>l ;
" Move to previous line match
nnoremap <leader>h ,

" Replace all
nnoremap <leader>s :%s//g<Left><Left>

" Quick quit
nnoremap <leader>qe :q!<CR>
nnoremap <leader>qa :qa<CR>
" Quick write quit
nnoremap <leader>qq ZZ
" Quick write
nnoremap <leader>qw :w<CR>
" Save file as sudo on files that require root permission
cnoremap !! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Session quicksave
nmap <F5> :mksession!<CR>

" Semi-colon command mode
nnoremap ; :
nnoremap <leader>; ;

" Using escape is a joke
inoremap jk <esc>

" ------------------------------------------------------------------------------
" Plugin
" ------------------------------------------------------------------------------

" -----------------------------------------------------------
" Shortcuts

nmap <leader>g :Goyo \| set bg=light \| set linebreak<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>u :UndotreeToggle<CR>
nmap <leader>v :VimwikiIndex

" CtrlP
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>t :CtrlPTag<CR>

" CtrlSF
nmap <leader>fs     <Plug>CtrlSFPrompt
nmap <leader>fp     <Plug>CtrlSFPwordPath
nnoremap <leader>ff :CtrlSFToggle<CR>
vmap <leader>f      <Plug>CtrlSFVwordPath

" -----------------------------------------------------------
" Settings

" Airline status bar arrows
let g:airline_powerline_fonts = 1

" CtrlP ignorance and tags
let g:ctrlp_custom_ignore = {
			\ 'dir': '\v[\/](\.(git|hg|svn)|\_site)$',
			\ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|bmp)$',
			\ }
let g:ctrlp_extensions = ['tag']
let g:ctrlp_root_markers = ['tags']

" CtrlSF auto-focus and defaults
let g:ctrlsf_auto_focus = {
			\ 'at': 'done',
			\ 'duration_less_than': 1000
			\ }
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_position = 'right'
let g:ctrlsf_winsize = '40%'

" Nerdtree bookmarks
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
if has('nvim')
	let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
else
	let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
endif

" Vimwiki file associations
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

" ------------------------------------------------------------------------------
" Larbs additions
" ------------------------------------------------------------------------------

" Shellcheck
map <leader>Sh :!clear && shellcheck -x %<CR>
" Spellcheck
map <leader>Sp :setlocal spell! spelllang=en_uk<CR>

" Compile groff/LaTeX/markdown/etc
map <leader>cc :w! \| !compiler "<c-r>%"<CR>
" Open corresponding .pdf/.html or preview
map <leader>cp :!opout <c-r>%<CR><CR>

" Enable Goyo by default for mutt writing
autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Toggle the bottom statusbar
let s:hide_bar = 0
function! ToggleHiddenAll()
	if s:hide_bar == 0
		let s:hide_bar = 1
		set laststatus=0
	else
		let s:hide_bar = 0
		set laststatus=2
	endif
endfunction
nnoremap <leader>H :call ToggleHiddenAll()<CR>

" Load command shortcuts generated from bm-dirs and bm-files via shortcuts script.
" Here leader is ";".
" So ":vs ;cfz" will expand into ":vs /home/<user>/.config/zsh/.zshrc"
" if typed fast without the timeout.
source ~/.config/nvim/shortcuts.vim

" -----------------------------------------------------------
" Automatic file updates

" When shortcut files are updated, renew bash and ranger configs with new material
autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated
autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Run a script that cleans out tex build files whenever a .tex file is closed
autocmd VimLeave *.tex !texclear %
" Recompile dwmblocks on config edit
autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" -----------------------------------------------------------
" File associations

autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

" ------------------------------------------------------------------------------
" Features
" ------------------------------------------------------------------------------

set bg=light
set clipboard+=unnamedplus
set go=a
set mouse=a
set noshowmode
set number relativenumber
set splitbelow splitright
set tags+=.git/tags
set title
set undofile
set wildmode=longest,list,full

" -----------------------------------------------------------
" Vim specific

if !has('nvim')
	set nocompatible                    " who wouldn't
	filetype indent plugin on           " activate
	syntax on                           " tasty syntax
	set encoding=utf-8
	set hlsearch                        " search highlighter
	set incsearch                       " search whilst typing
	set laststatus=2                    " status bar on open

	set backupdir=$VIM/backup
	set undodir=$VIM/undo
	set tags+=./tags;
endif

" ------------------------------------------------------------------------------
" Autocommands
" ------------------------------------------------------------------------------

" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Move cursor to last line on open
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
			\| exe "normal! g'\"" | endif
" Deletes trailing whitespace and eof newlines on save
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
" Set cwd to location of current file
autocmd BufEnter * silent! lcd %:p:h

" ------------------------------------------------------------------------------
" Highlights
" ------------------------------------------------------------------------------

highlight Search ctermfg=189 ctermbg=55
highlight! link Folded Search
highlight! link Visual Search
highlight! link ctrlsfLnumMatch Search
highlight! link ctrlsfMatch Search

" Remove diff highlighting for altered characters only
if &diff
	highlight! link DiffText MatchParen
endif
