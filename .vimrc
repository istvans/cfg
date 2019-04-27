syntax on

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set dir=./.vim-swap//
set dir+=~/.vim/swap//
set dir+=~/tmp//
set dir+=.

" Setup indentation
set shiftwidth=4                                                        " Number of spaces when indenting
set tabstop=4                                                           " Number of spaces to use for tabs
set expandtab                                                           " Expand tabs and always use spaces
set smarttab                                                            " A TAB in an indent will insert shiftwidth spaces

" Setup basic editor behaviour
set hlsearch                                                            " Highlight search results
set ignorecase                                                          " Ignore case in searches
set smartcase                                                           " Case sensitive search if there are uppercase letters
set showmatch                                                           " Show matching pairs of brackets
set ruler                                                               " Show cursor position all the time
set incsearch                                                           " Do incremental seacrhing
set bs=2                                                                " What backspace can do in insert mode
set background=dark                                                     " Indicate that we have light background color
set showcmd                                                             " Display incomplete commands
set number                                                              " Show line numbering
set mat=5                                                               " How many tenth of a seconds to highlight matching bracket
set so=5                                                                " Number of screen lines to show around the cursor
set ffs=unix,dos                                                        " List of file formats to look for when editing a file
set laststatus=2                                                        " Always display a status line
set wildmenu                                                            " Command-line completion shows a list of matches
set noeb                                                                " Turn off edge bell
set noeol                                                               " Prevent automatic new line at the end of lines
set nopaste                                                             " Off indenting for copy-paste
set vb                                                                  " Turn on visual bell

" Enable 'new' features
if v:version > 704 || v:version == 704 && has("patch1689")
    set nofixeol                                                        " Preserve original end of line situation
    set listchars=eol:$,space:.,tab:>-,trail:~,extends:>,precedes:<     " Set how to show whitespaces
endif

" Folding setup
set foldenable
set foldmethod=indent
set foldlevel=100

" Key bindings
map <F4> :call Whitespaces_on_off()<CR>
map <F5> :call Wrap_on_off()<CR>
map <F6> :call Scb_on_off()<CR>
map <F7> :call Light_background_on_off()<CR>
map <F8> :call Ln_on_off()<CR>
set pastetoggle=<F9> " Toggle on/off indenting, for copy-paste (e.g. "set paste")
map ee :Explore<CR>
map ss :call Save_files_session_and_quit()<CR>
map ll :source ~/last_session.vim<CR>
map mm :mksession! ~/last_session.vim<CR>
map xx :xa!<CR>
map yy :qall!<CR>
map zz :qall!<CR>
nmap <C-H> :tabprev<CR>
nmap <C-L> :tabnext<CR>

" =========================================
" Functions
" =========================================

" Toggle showing whitespaces
func! Whitespaces_on_off()
  if &list
    :windo set nolist
  else
    :windo set list
  endif
endfunc

" Toggle text wrapping
func! Wrap_on_off()
  if &wrap
    :windo set nowrap
  else
    :windo set wrap
  endif
  echo "wrap is " . &wrap
endfunc

" Toggle scrollbind
func! Scb_on_off()
  if &scb
    :windo set noscb
  else
    :windo set scb
  endif
  echo "scrollbind is " . &scb
endfunc

" Toggle light background
func! Light_background_on_off()
  if "dark" == &background
    :windo set background=light
  else
    :windo set background=dark
  endif
endfunc

" Toggle line numbers
func! Ln_on_off()
  if &nu
    :windo set nonu
  else
    :windo set nu
  endif
endfunc

" Save files, session and quit
func! Save_files_session_and_quit()
  :wa
  :mksession! ~/last_session.vim
  :qa!
endfunc

" =========================================
" AutoCMD
" =========================================

" Only do this part when compiled with autocommands support
if has("autocmd")
  " Enable file type detection and load indent files for lang-dependent
  " indenting
  filetype plugin indent on

  " Put these to an autocmd group, so that we can delete them easily
  augroup vimrcCmd
    au!
    " For all text files, set text width to 78 chars -- not a good idea
    " autocmd FileType text setlocal textwidth=78
    autocmd BufEnter * :syntax sync fromstart
    au BufRead *.a set ft=sh
    
    au filetypedetect BufNewFile,BufRead Makefile* set noexpandtab
    
    autocmd BufRead,BufNewFile *.txt,README,TODO,CHANGELOG,NOTES
           \ setlocal autoindent expandtab tabstop=8 softtabstop=2 shiftwidth=2
           \ textwidth=70 wrap formatoptions=tcqn
           \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>
    
  augroup END
else  " we have no autocmd
  set autoindent      " Always set autoindenting on
  set smartindent     " Use spaces when indenting
endif " has("autocmd")

" Highlight settings for vimdiff
highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=black
highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black
highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black
highlight DiffText term=reverse cterm=bold ctermbg=blue ctermfg=white

" Highlight background of text that goes over the 100 column limit
highlight OverLength ctermbg=lightgray ctermfg=black guibg=lightgray guifg=black
match OverLength /\%>100v.\+/

" Ignore whitspace in vimdiff
set diffopt+=iwhite
