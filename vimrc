" vim runtime config
" Che-Huai Lin <lzh9102@gmail.com>

" Pre-settings {{{
" allow utf-8 characters in vimrc
scriptencoding utf-8
" load python2 (python2 cannot be used after loading python3)
if has('python')
end
" Pre-settings End}}}

" Vundle {{{

" Vundle Setup {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'
" }}}

" == Bundles ==
" Languages {{{
Bundle 'jceb/vim-orgmode'
Bundle 'vim-scripts/Ada-Bundle'
Bundle 'klen/python-mode'
Bundle 'helino/vim-json'
Bundle 'HyperList'
Bundle 'vim-scripts/DoxyGen-Syntax'
Bundle 'c9s/perlomni.vim'
Bundle 'myhere/vim-nodejs-complete'
Bundle 'Rip-Rip/clang_complete'
Bundle 'xaizek/vim-inccomplete'
Bundle 'digitaltoad/vim-jade'
"Bundle 'xolox/vim-notes'
"Bundle 'xolox/vim-misc'
" NOTE: riv uses <C-e> as a prefix, so it will cause delay on scroll down
"Bundle 'Rykka/riv.vim'
"Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
"Bundle 'vimoutliner/vimoutliner'
"Bundle 'davidhalter/jedi-vim'
"Bundle 'ingydotnet/vroom-pm'
" }}}

" Editing {{{
Bundle 'Lokaltog/vim-easymotion'
"Bundle 'git@github.com:lzh9102/YouCompleteMe.git'
Bundle 'AutoComplPop'
Bundle 'surround.vim'
"Bundle 'tpope/vim-surround'
Bundle 'tsaleh/vim-matchit'
Bundle 'vim-scripts/closetag.vim'
Bundle 'SirVer/ultisnips'
"Bundle 'snipMate'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-repeat'
"Bundle 'kana/vim-fakeclip'
Bundle 'Align'
Bundle 'camelcasemotion'
"Bundle 'kien/rainbow_parentheses.vim'
Bundle 'vim-scripts/utl.vim'
" }}}

" File and Buffer {{{
Bundle 'kien/ctrlp.vim'
Bundle 'a.vim'
Bundle 'vim-scripts/FencView.vim'
Bundle 'danro/rename.vim'
Bundle 'lzh9102/vim-indentfinder'
Bundle 'troydm/easybuffer.vim'
Bundle 'chrisbra/SudoEdit.vim'
"Bundle 'ldx/vim-indentfinder'
"Bundle 'vim-scripts/vim-fuzzyfinder'
"Bundle 'ciaranm/detectindent'
" }}}

" Extra Utilities {{{
Bundle 'tpope/vim-fugitive'
Bundle 'taglist.vim'
Bundle 'calendar.vim'
Bundle 'winmanager'
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'guns/xterm-color-table.vim'
Bundle 'benmills/vimux'
Bundle 'mileszs/ack.vim'
Bundle 'majutsushi/tagbar'
" }}}

" Themes {{{
"Bundle 'altercation/vim-colors-solarized'
"Bundle 'twilight'
Bundle 'lzh9102/vim-distinguished'
" }}}

" Libraries {{{
Bundle 'Shougo/vimproc.vim'
"Bundle 'vim-scripts/L9'
" }}}

" Others {{{
"Bundle 'HJKL'
"Bundle 'sophacles/vim-bundle-sparkup'
" }}}

" {{{
filetype plugin indent on
filetype plugin on
" }}}

" Vundle End }}}

" Core Editor Settings {{{

"    Appearance {{{
set number             " show line numbers
"set rnu                " relative numbering
set cursorline         " highlight the current line
set noshowmatch        " vim already highlights matching parenthesis
set colorcolumn=80     " display 80-character column
set laststatus=2       " always display status bar
set wildmenu           " command completion menu
set wildmode=list:full " menu: match until the longest common prefix
set display+=lastline  " show incomplete lines

" folding
"set foldmethod=syntax
"set foldlevelstart=99
set foldmethod=marker  " fold by markers

" colorscheme
"syntax enable
"set background=dark
"colorscheme solarized
" `distinguished` needs 256-color terminal
if &t_Co == 256
	colorscheme distinguished
else
	" popup-menu color settings
	highlight PmenuSel ctermbg=Green ctermfg=Black
	highlight Pmenu ctermbg=Brown ctermfg=Black
endif

" statusline
function! FugitiveStatusLine()
	if exists("*fugitive#statusline")
		return fugitive#statusline()
	else
		return ""
	endif
endfunction
set statusline=%<\ [%F]             " filename with path
set statusline+=\ [%{&encoding},    " encoding
set statusline+=%{&fileformat}]           " file format
set statusline+=\ %{FugitiveStatusLine()} " git branch (when in git repo)
set statusline+=%m
set statusline+=%=\ %y\ %l,\ %c\ \<\ %P\ \>

" highlight non-indent tab characters (2012-09-05)
match VertSplit /[^\t]\zs\t\+/

" [vim_listchars] show special characters
set listchars=eol:¬,tab:>-

"    Appearance End }}}

"    Editing {{{

" omni completion
set ofu=syntaxcomplete#Complete

" virutaledit mode
set virtualedit=block

" default indentation settings
set autoindent
set backspace=2
set noexpandtab
set tabstop=3
set shiftwidth=3
set softtabstop=3

" make it possible to recover from accidentally deleting a line in insert mode
"inoremap <c-u> <c-g>u<c-u>

" exclude '=' as valid filename characters to ease completion in shell
" scripts.
set isfname-==

" enable repeat indent/unindent
vnoremap > >gv
vnoremap < <gv

" inserting date and time
command Date execute 'normal a<C-r>=strftime("%Y-%m-%d")<CR><ESC>'
command Time execute 'normal a<C-r>=strftime("%H:%M:%S")<CR><ESC>'
command DateTime execute 'normal a<C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR><ESC>'

" disable mouse scrolling completely
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <C-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>
map <C-ScrollWheelDown> <nop>
map <ScrollWheelLeft> <nop>
map <S-ScrollWheelLeft> <nop>
map <C-ScrollWheelLeft> <nop>
map <ScrollWheelRight> <nop>
map <S-ScrollWheelRight> <nop>
map <C-ScrollWheelRight> <nop>
imap <ScrollWheelUp> <nop>
imap <S-ScrollWheelUp> <nop>
imap <C-ScrollWheelUp> <nop>
imap <ScrollWheelDown> <nop>
imap <S-ScrollWheelDown> <nop>
imap <C-ScrollWheelDown> <nop>
imap <ScrollWheelLeft> <nop>
imap <S-ScrollWheelLeft> <nop>
imap <C-ScrollWheelLeft> <nop>
imap <ScrollWheelRight> <nop>
imap <S-ScrollWheelRight> <nop>
imap <C-ScrollWheelRight> <nop>
set mouse=a

"    Editing End }}}

"    File & Buffer {{{

" Return to last edit position when opening files
au BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" load templates (2012-09-05)
au BufNewFile * call LoadTemplate()
function! LoadTemplate()
	let extension = expand('%:e')
	let name_var = substitute(toupper(expand("%:t")), '[^a-zA-Z0-9_]', '_', "g")
	silent! exe 'read ~/.vim/templates/tmpl.' . extension
	silent! exe 'normal k"_dd'
	silent! exe '%s/\$(FILE_CAP_VAR)/' . name_var . '/g'
	silent! exe '/\$(CURSOR_POS)'
	silent! exe 'normal f$"_df)'
endfunction

" swap and backup file settings
" Disable Backup and Swap File
"set nobackup
"set nowritebackup
"set noswapfile
set nobackup
set swapfile
set dir=~/.vimswp//

" recursively search for "tags" file upwards till reaching root
set tags=./tags;,./TAGS;,tags,TAGS

" disable modeline for security (prevent arbitrary code execution)
" see http://www.guninski.com/vim1.html
set modelines=0

"    File & Buffer End }}}

"    Shortcut {{{

" save file and make
nmap <C-c><C-m> :update<CR>:make<CR>

" Leaders (2012-09-04)
let maplocalleader = '-'
let mapleader = '\'

" switching tabs
nmap <C-n> gt
nmap <C-p> gT
nmap <C-c><C-n> :tabnew 

" toggle hlsearch
nnoremap <C-c><C-h> :set hlsearch!<CR>

" [vim_listchars] toggle show special characters
nnoremap <C-c><C-l> :set list! list?<CR>

" [plugin_taglist] toggle ctags
"nmap <F11> :Tlist<CR>
"nmap <C-c><C-t> :Tlist<CR>
nmap <C-c><C-t> :Tagbar<CR>

" [plugin_nerdtreetabs] toggle NERDTree explorer (shared across tabs)
"nmap <F12> :NERDTreeTabsToggle<CR>
nmap <C-c><C-f> :NERDTreeTabsToggle<CR>

" toggle relative numbering
nmap <C-c><C-r> :set rnu!<CR>

" [plugin_easybuffer]
nnoremap <C-c><C-b> :EasyBuffer<CR>

" [plugin_vimux]
nmap <C-c><C-e> :VimuxPromptCommand<CR>

" update (write to disk if modified)
nmap <C-c><C-u> :update<CR>

" write as root
" superceded by sudoedit plugin
"function! WriteAsRoot()
"	w! !sudo tee % > /dev/null
"	e!
"endfunction
"command WriteAsRoot call WriteAsRoot()

"    Shortcut End }}}

" File Types {{{
" force "*.md" to be opened as markdown
au BufNewFile,BufRead *.md set ft=markdown
" }}}

" Core Editor Settings End }}}

" Plugin Settings {{{

" detectindent settings
"au BufReadPost * :DetectIndent
"let g:detectindent_preferred_expandtab = 0
"let g:detectindent_preferred_indent = 3

" vim-orgmode (2012-09-04)
" <S-CR> doesn't work, so remap the function to <CR>
au FileType org nmap <CR> <Plug>OrgNewHeadingBelowNormal

" Utl settings
let g:utl_cfg_hdl_scm_http = ':!bash -c "firefox %u >& /dev/null &"'

" Align settings
let g:Align_xstrlen=3 " fix for wide characters

" enable doxygen syntax highlighting (depends on the DoxyGen-Syntax plugin)
au Syntax {cpp,c,idl} runtime syntax/doxygen.vim 

" FencView settings (2012-10-17)
" disable auto detection of encoding
let g:fencview_autodetect=0

" easymotion leader
let g:EasyMotion_leader_key = '-'

" [plugin_nerdtreetabs]
let g:nerdtree_tabs_open_on_gui_startup = 0

" nerdtree plugins
let g:nerdtree_open_cmd = 'kde-open'
let g:nerdtree_add_to_playlist_cmd = 'smplayer -add-to-playlist'

" python-mode settings
let g:pymode_lint = 0
let g:pymode_folding = 0 
let g:pymode_rope = 0

" vim-outliner: allow using tab and space to toggle folding
"au Filetype vo_base nnoremap <TAB> za
"au Filetype vo_base nnoremap <SPACE> za

" fuzzyfinder
nnoremap <Leader>ff :FufFile!<CR>
nnoremap <Leader>fb :FufBuffer!<CR>
nnoremap <Leader>ft :FufTag!<CR>

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" ctrlp
let g:ctrlp_map = '<c-c><c-p>'

" rainbow parentheses
"function! ToggleRainbowParentheses()
"	:RainbowParenthesesToggle
"	:RainbowParenthesesLoadRound
"	:RainbowParenthesesLoadSquare
"	:RainbowParenthesesLoadBraces
"endfunction
"command RainbowParentheses call ToggleRainbowParentheses()

" AutoComplPop (auto completion popup)
"   disable: keywords, files
let g:acp_behaviorKeywordLength = -1
let g:acp_behaviorFileLength = -1
"   enable: perl
let g:acp_behaviorPerlOmniLength = 0

" SudoEdit
let g:sudo_no_gui = 1

" Tagbar
let g:tagbar_left = 1
let g:tagbar_width = 30

" Notes
"let g:notes_directories = ['~/Dropbox/Documents/notes']
"let g:notes_suffix = '.org'
"let g:notes_title_sync = 'no'
"let g:notes_smart_quotes = 0

" Plugin Settings End }}}