let mapleader = ","
set gdefault
set nu
set ruler
set hls
set foldmethod=syntax
set nocompatible              " be iMproved, required
filetype off                  " required


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'

" snippet engine
Plugin 'SirVer/ultisnips'
"
" " Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" hexman, simple hex file viewing
Plugin 'vim-scripts/hexman.vim'

" " My own Libreoffice snippets
Plugin 'mmohrhard/libosnippets'

Bundle 'octol/vim-cpp-enhanced-highlight'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" " To ignore plugin indent changes, instead use:
" "filetype plugin on
" "
" " Brief help
" " :PluginList          - list configured plugins
" " :PluginInstall(!)    - install (update) plugins
" " :PluginSearch(!) foo - search (or refresh cache first) for foo
" " :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line


" use modelines
" set modeline
" set modelines=3     " number lines checked for modelines

" tab settings
set shiftwidth=4
set softtabstop=4
set expandtab

" indentation settings
set autoindent
set copyindent

" cindent settings
set cindent
set cino=b1,g0,N-s,t0
set cinkeys=0{,0},0),:,0#,!^F,o,O,e,0=break

" I don't need backup files
set noswapfile
set nobackup

" ignore generated files
set wildignore=*.o,*~,*.pyc

" store undo to file
set undofile

" don't use compatible mode
set nocompatible

" use <tab> for jumping
nnoremap <tab> %
vnoremap <tab> %

" remove all trailing whitespaces
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" quickly open vimrc file
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
noremap <silent> <leader>eV :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" vertical split + move to it
nnoremap <leader>w <C-w>v<C-w>l

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/


" direct access to my todo lists
map <leader>aw :e ~/todo/work<cr>
map <leader>al :e ~/todo/libo<cr>
map <leader>an :e ~/todo/notes<cr>
map <leader>as :e ~/todo/scripts<cr>


" create new lines in normal mode
map <leader>o o<ESC>
map <leader>O O<ESC>

" pasting from the global register
map <leader>p o<ESC>"+p<ESC>
map <leader>P O<ESC>"+p<ESC>

" yanking to the global register
map <leader>y "+y

" everything around the cscpe configuration
source ~/.vim/plugin/cscope_maps.vim

" taglist
nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F7> :TlistOpen<CR>
"set Tlist_Process_File_Always=1

" OmniCppComplete
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+ias --languages=c++ --exclude=instdir/* --exclude=workdir/* --exclude=solver/* --extra=+q .<CR>

" XML formatter
function! DoFormatXML() range
	" Save the file type
	let l:origft = &ft

	" Clean the file type
	set ft=

	" Add fake initial tag (so we can process multiple top-level elements)
	exe ":let l:beforeFirstLine=" . a:firstline . "-1"
	if l:beforeFirstLine < 0
		let l:beforeFirstLine=0
	endif
	exe a:lastline . "put ='</PrettyXML>'"
	exe l:beforeFirstLine . "put ='<PrettyXML>'"
	exe ":let l:newLastLine=" . a:lastline . "+2"
	if l:newLastLine > line('$')
		let l:newLastLine=line('$')
	endif

	" Remove XML header
	exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

	" Recalculate last line of the edited code
	let l:newLastLine=search('</PrettyXML>')

	" Execute external formatter
	exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

	" Recalculate first and last lines of the edited code
	let l:newFirstLine=search('<PrettyXML>')
	let l:newLastLine=search('</PrettyXML>')

	" Get inner range
	let l:innerFirstLine=l:newFirstLine+1
	let l:innerLastLine=l:newLastLine-1

	" Remove extra unnecessary indentation
	exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

	" Remove fake tag
	exe l:newLastLine . "d"
	exe l:newFirstLine . "d"

	" Put the cursor at the first line of the edited code
	exe ":" . l:newFirstLine

	" Restore the file type
	exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

" fugitive short cuts
nmap <leader>ga :Gwrite<CR>
nmap <silent> <leader>gc :Gcommit<CR>
nmap <leader>gb :Gblame<CR>
nmap <leader>gl :Glog<CR>

nmap <leader>ty :YcmCompleter GetType<CR>
nmap <leader>gi :YcmCompleter GoToInclude<CR>
nmap <leader>td :YcmCompleter GoToDefinition<CR>
nmap <leader>gd :YcmCompleter GoToDeclaration<CR>
nmap <leader>to :YcmCompleter GoTo<CR>

" UltiSnips remappings
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" YcmConfigs
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1

" editing of zip files
au BufReadCmd *.odt,*.ott,*.ods,*.ots,*.odp,*.otp,*.odg,*.otg,*.odb,*.odf,*.odm,*.odc call zip#Browse(expand("<amatch>"))
au BufReadCmd *.sxw,*.stw,*.sxc,*.stc,*.sxi,*.sti,*.sxd,*.std,*.odb,*.sxm,*.sxg,*.sxs call zip#Browse(expand("<amatch>"))
au BufReadCmd *.bau call zip#Browse(expand("<amatch>"))
au BufReadCmd *.oxt call zip#Browse(expand("<amatch>"))
au BufReadCmd *.docx,*.dotx,*.dotm,*.docm,*.xlsx,*.xltx,*.xlsm,*.xsltm,*.pptx,*.potx,*.ppsx,*.pptm,*.ppsm,*.potm call zip#Browse(expand("<amatch>"))

" some stored macros
let @q = 'bi/*ea*/'

set t_Co=256
colorscheme candyVirus
