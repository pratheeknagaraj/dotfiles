" VIM Configuration File
" Description: .vimrc file for general purpose usage
" Author: Pratheek Nagaraj

" filetype plugin on

" set UTF-8 encoding
set enc=utf-8
" use indentation of previous line
set autoindent
" use intelligent indentation
set smartindent
" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
" wrap lines at 120 chars. 80 is too restrictive
" set textwidth=120 " disable textwidth just highlight for now
" turn syntax highlighting on
set t_Co=256
syntax on

" turn line numbers on
set number
" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" Enhanced keyboard mappings
"
" in diff mode we use the spell check keys for merging
if &diff
  " diff settings
  map <M-Down> ]c
  map <M-Up> [c
  map <M-Left> do
  map <M-Right> dp
  map <F9> :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg
else
  " spell settings
  :setlocal spell spelllang=en
  " set the spellfile - folders must exist
  set spellfile=~/.vim/spellfile.add
  map <M-Down> ]s
  map <M-Up> [s
endif

""" STATUS LINE

" set statusline+=%F
set laststatus=2

" spiiph's
set statusline=
"set statusline+=%<\                       " cut at start
"set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
"set statusline+=%-40f\                    " path
"set statusline+=%=%1*%y%*%*\              " file type
"set statusline+=%10((%l,%c)%)\            " line and column
"set statusline+=%P                        " percentage of file


"" jamessan's
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset
"
"
"" tpope's
"set statusline=[%n]\ %<%.99f\ %h%w%m%r%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%y%=%-16(\ "%c-%v\ %)%P
"
"
"" frogonwheels'
"set statusline=%f%w%m%h%1*%r%2*%{VarExists('b:devpath','<"Rel>')}%3*%{VarExists('b:relpath','<>')}%{XLockStat()}%=%-15(%l,%c%V%)%P
"
"
"" godlygeek's
"let &statusline='%<%f%{&mod?"[+]":""}%r%{&fenc !~ "^$\\|utf-8" || &bomb ? "[".&fenc.(&bomb?"-bom":"")."]" ""}%=%15.(%l,%c%V %P%)'
"
"
"" Another way to write godlygeeks:
"set statusline=%<%f%m%r%{Fenc()}%=%15.(%l,%c%V\ %P%)
"function! Fenc()
"    if &fenc !~ "^$\|utf-8" || &bomb
"        return "[" . &fenc . (&bomb ? "-bom" : "" ) . "]"
"    else
"        return ""
"    endif
"endfunction"

""" SPLIT NAVIGATION
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


""" WHITESPACE

nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>


""" SPELLING

" Spelling
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1
highlight clear SpellCap
highlight SpellCap term=underline cterm=bold
highlight clear SpellRare
highlight SpellRare term=underline cterm=bold
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=bold

""" TABS

nnoremap <C-S-Left> :tabprevious<CR>
nnoremap <C-S-Right> :tabnext<CR>
nnoremap <silent> <A-S-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-S-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

""" Line Highlighting

highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
highlight CursorLineNR cterm=NONE ctermbg=9 ctermfg=0 guibg=NONE guifg=NONE

""" 120 character width

let &colorcolumn=join(range(121,999),",")
highlight ColorColumn ctermbg=232 guibg=#bbbbbb

""" Width for Git

au FileType gitcommit setlocal tw=72

set cursorline
